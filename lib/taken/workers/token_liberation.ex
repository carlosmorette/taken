defmodule Taken.Workers.TokenLiberationWorker do
  use Oban.Worker, queue: :token_liberation, max_attempts: 5

  require Logger
  alias Taken.DTOs.Internal.RegisterTokenUsageDTO
  alias Taken.Operations.TokenLiberationOperation

  @token_expiration_in_seconds Application.compile_env(:taken, :token_expiration_in_seconds)

  def enqueue(%RegisterTokenUsageDTO{} = dto) do
    %{user_id: dto.user_id, token_id: dto.token_id}
    |> __MODULE__.new()
    |> Oban.insert(
      scheduled_at:
        NaiveDateTime.add(
          NaiveDateTime.utc_now(),
          @token_expiration_in_seconds
        )
    )
  end

  @impl true
  def perform(%Oban.Job{
        attempt: attempt,
        args: %{"user_id" => user_id, "token_id" => token_id}
      }) do
    case TokenLiberationOperation.run(%{user_id: user_id, token_id: token_id}) do
      {:ok, :ok} ->
        Logger.info("[#{__MODULE__}] Success to liberate token #{token_id} with user_id #{user_id}")
        :ok

      {:error, error} ->
        Logger.error("""
        [#{__MODULE__}] Attempt #{attempt} to liberate token.
        args: user_id: #{user_id}, token_id: #{token_id}
        error error: #{inspect(error)}
        """)

        {:error, error}
    end
  end
end

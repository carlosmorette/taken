defmodule Taken.BackgroundJobs.ExpireTokenJob do
  use Oban.Worker, queue: :expire_token, max_attempts: 5

  alias Taken.Dtos.Internal.RegisterTokenUsageDTO

  @token_expiration_in_seconds Application.compile_env(:taken, :token_expiration_in_seconds)

  def enqueue(%RegisterTokenUsageDTO{} = dto) do
    %{user_id: dto.user_id, token_id: dto.token_id}
    |> Oban.Job.new()
    |> Oban.insert(
      scheduled_at:
        DateTime.add(
          DateTime.utc_now(),
          @token_expiration_in_seconds,
          :second
        )
    )
  end

  def peform(%Oban.Job{
    attempt: attempt,
    args: %{"user_id" => user_id, "token_id" => token_id}
    }) do
      if attempt > 3 do
        # log
      end

      # log quando der certo
  end
end

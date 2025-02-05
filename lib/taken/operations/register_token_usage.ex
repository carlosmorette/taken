defmodule Taken.Operations.RegisterTokenUsageOperation do
  require Logger

  alias Taken.Repositories.TokenUsageHistoryRepository
  alias Taken.Dtos.Internal.RegisterTokenUsageDTO
  alias Taken.Dtos.External.ErrorDTO

  alias Taken.Repo
  alias Taken.Repositories.CacheRepository

  @max_active_tokens_limit 100

  def run(payload) do
    Logger.metadata(:operation_id, Ecto.UUID.generate())

    Repo.transaction(fn repo ->
      with {:ok, %RegisterTokenUsageDTO{} = insert_dto} <- validate_input(payload),
           :ok <- validate_active_tokens_on_cache(),
           %_{} <- TokenUsageHistoryRepository.insert!(insert_dto),
           :ok <- CacheRepository.increment_active_tokens() do
           #:ok <- enqueue_token_expiration(insert_dto) do
        {:ok, insert_dto}
      else
        {:error, :limit_exceeded} -> %ErrorDTO{message: "Não há mais tokens disponíveis", details: %{}}
      end
    end)
  end

  defp validate_input(params) do
    case RegisterTokenUsageDTO.validate(params) do
      {:ok, data} ->
        {:ok, data}

      {:error, error} ->
        {:error, error}
    end
  end

  def validate_active_tokens_on_cache() do
    count = CacheRepository.get_active_tokens_count()

    if count < @max_active_tokens_limit do
      ## Log
      {:error, :limit_exceeded}
    else
      :ok
    end
  end
end

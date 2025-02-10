defmodule Taken.Operations.RegisterTokenUsageOperation do
  require Logger

  alias Taken.Entities.TokenEntity
  alias Taken.Repositories.{TokenRepository, UsageHistoryRepository}
  alias Taken.Operations.TokenLiberationOperation
  alias Taken.Workers.TokenLiberationWorker
  alias Taken.DTOs.{Internal.RegisterTokenUsageDTO, External.ErrorDTO}
  alias Taken.Repo

  def run(payload) do
    Logger.metadata(operation_id: Ecto.UUID.generate())

    Repo.transaction(fn ->
      Repo.query!("set transaction isolation level serializable;")

      with {:ok, %RegisterTokenUsageDTO{} = register_dto} <- RegisterTokenUsageDTO.validate(payload),
           true <- user_available?(register_dto),
           :ok <- maybe_liberate_token() do
        process_token_usage(register_dto)
      else
        error -> handle_error(error)
      end
    end)
  end

  defp process_token_usage(%RegisterTokenUsageDTO{} = register_dto) do
    TokenRepository.update_to_active(register_dto.token_id)
    UsageHistoryRepository.insert!(register_dto)
    TokenLiberationWorker.enqueue(register_dto)
    log_usage_success(register_dto)
    register_dto
  end

  defp handle_error(false), do: error_response("Os dados informados estão incorretos", %{})
  defp handle_error({:error, error}) when is_list(error), do: error_response("Os dados informados estão incorretos", error)
  defp handle_error({:error, _error}), do: error_response("Aconteceu um erro ao registrar uso de token", %{})

  defp error_response(message, details) do
    {:error, %ErrorDTO{message: message, details: details}}
  end

  def user_available?(%RegisterTokenUsageDTO{} = dto) do
    is_nil(UsageHistoryRepository.find_not_finished_user_token_usage(dto))
  end

  def maybe_liberate_token() do
    if TokenRepository.count_active() == 100 do
      last_active = TokenRepository.find_last_active()
      case TokenLiberationOperation.run(last_active) do
        :ok -> log_token_liberation_success(last_active)
        {:error, error} = err -> log_token_liberation_error(last_active, error); err
      end
    else
      :ok
    end
  end

  defp log_token_liberation_success(%TokenEntity{} = token) do
    Logger.info("[#{__MODULE__}] Success to liberate token id #{token.id}")
  end

  defp log_usage_success(%RegisterTokenUsageDTO{} = register_dto) do
    Logger.info("[#{__MODULE__}] Success to register token usage. UserId: #{register_dto.user_id}, TokenID: #{register_dto.token_id}")
  end

  defp log_token_liberation_error(token, error) do
    Logger.error("""
    [#{__MODULE__}] Error to liberate token
    token_id: #{token.id}
    error: #{inspect(error)}
    """)
  end
end

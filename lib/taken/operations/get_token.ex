defmodule Taken.Operations.GetTokenOperation do
  alias Taken.Mappers.TokenMapper
  alias Taken.DTOs.External.ErrorDTO
  alias Taken.Repositories.UsageHistoryRepository
  alias Taken.Repositories.TokenRepository
  alias Taken.DTOs.Internal.GetTokenDTO

  alias Taken.Entities.TokenEntity

  def run(params) do
    with {:ok, dto} <- GetTokenDTO.validate(params) do
      find_and_map(dto)
    else
      error -> error_response("Os dados informados estão incorretos", error)
    end
  end

  def find_and_map(%GetTokenDTO{} = dto) do
    case TokenRepository.find(token_id: dto.token_id) do
      nil -> error_response("Token não encontrado")
      token -> {:ok, handle_token(token)}
    end
  end

  def handle_token(%TokenEntity{status: :active} = token) do
    usage_history =
      token.usage_history
      |> Enum.find(&is_nil(&1.finished_at))
      |> UsageHistoryRepository.preload_user()

    TokenMapper.map_active_to_dto(token, usage_history.user)
  end

  def handle_token(%TokenEntity{status: :available} = token) do
    TokenMapper.map_available_to_dto(token)
  end

  defp error_response(message, details \\ %{}) do
    {:error, %ErrorDTO{message: message, details: details}}
  end
end

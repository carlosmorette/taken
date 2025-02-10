defmodule Taken.Operations.GetTokensOperation do
  alias Taken.DTOs.Internal.GetTokensDTO
  alias Taken.DTOs.External.{ErrorDTO, PageDTO}
  alias Taken.Repositories.TokenRepository
  alias Taken.Mappers.TokenMapper

  def run(params) do
    with {:ok, %GetTokensDTO{} = dto} <- GetTokensDTO.validate(params) do
      {:ok, find_and_map(dto)}
    else
      error -> handle_error(error)
    end
  end

  def find_and_map(%GetTokensDTO{} = dto) do
    [limit: dto.limit, offset: dto.offset]
    |> TokenRepository.find_all()
    |> Enum.map(&TokenMapper.map_entity_to_dto/1)
    |> then(fn dtos -> %PageDTO{count: length(dtos), limit: dto.limit, offset: dto.offset, data: dtos} end)
  end

  defp handle_error({:error, error}) when is_list(error), do: error_response("Os dados informados estão incorretos", error)

  defp error_response(message, details) do
    {:error, %ErrorDTO{message: message, details: details}}
  end
end

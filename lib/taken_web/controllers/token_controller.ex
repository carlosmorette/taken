defmodule TakenWeb.TokenController do
  alias Taken.Operations.{RegisterTokenUsageOperation, GetTokens}
  use Phoenix.Controller

  def register_usage(conn, body_params) do
    case RegisterTokenUsageOperation.run(body_params) do
      {:ok, {:error, error_dto}} ->
        json(conn, error_dto)

      {:ok, register_dto} ->
        json(conn, register_dto)

      {:error, error_dto} ->
        json(conn, error_dto)
    end
  end

  def list(conn, params) do
    case GetTokens.run(params) do
      {:ok, dtos} ->
        json(conn, dtos)
      {:error, error_dto} ->
        json(conn, error_dto)
    end
  end
end

defmodule TakenWeb.TokenController do
  alias Taken.Operations.RegisterTokenUsageOperation
  use Phoenix.Controller

  def register_usage(conn, body_params) do
    case RegisterTokenUsageOperation.run(body_params) do
      {:ok, {:error, error_dto}} ->
        json(conn, error_dto)

      {:ok, register_dto} ->
        IO.inspect(register_dto, label: "REGISTER_DTO")
        json(conn, register_dto)

      {:error, error_dto} ->
        json(conn, error_dto)
    end
  end
end

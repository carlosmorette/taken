defmodule Taken.DTOs.Internal.GetTokenDTO do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :token_id, :string
  end

  defp changeset(entity \\ %__MODULE__{}, attrs) do
    entity
    |> cast(attrs, [:token_id])
    |> validate_required([:token_id])
  end

  def validate(params) do
    case changeset(params) do
      %Ecto.Changeset{valid?: true, data: data, changes: changes}->
        {:ok, struct(data, changes)}

      %Ecto.Changeset{valid?: false, errors: errors} ->
        {:error, Enum.map(errors, fn {k, {v, _}} -> Enum.into(%{k => v}, %{}) end)}
    end
  end
end

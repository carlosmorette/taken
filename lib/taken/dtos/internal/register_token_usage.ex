defmodule Taken.Dtos.Internal.RegisterTokenUsageDTO do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :user_id, :id
    field :token_id, :id
  end

  defp changeset(entity \\ %__MODULE__{}, attrs) do
    entity
    |> cast(attrs, [:user_id, :token_id])
    |> validate_required([:user_id, :token_id])
  end

  def validate(params) do
    case changeset(params) do
      %Ecto.Changeset{valid?: true, data: data} -> {:ok, data}
      %Ecto.Changeset{valid?: false, errors: errors} -> {:error, errors}
    end
  end
end

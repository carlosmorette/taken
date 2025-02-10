defmodule Taken.DTOs.Internal.GetTokensDTO do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :limit, :integer
    field :offset, :integer
  end

  defp changeset(entity \\ %__MODULE__{}, attrs) do
    entity
    |> cast(attrs, [:limit, :offset])
    |> validate_required([:limit, :offset])
    |> validate_number(:limit, less_than_or_equal_to: 200)
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

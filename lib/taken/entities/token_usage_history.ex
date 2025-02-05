defmodule Taken.Entities.UsageHistory do
  use Ecto.Schema
  import Ecto.Changeset

  alias Taken.Entities.{User, Token}

  @contraint_message "Usuário já possui token ativo"

  schema "token_usage_history" do
    belongs_to :user, User
    belongs_to :token, Token

    timestamps()
  end

  defp changeset(entity \\ %__MODULE__{}, attrs) do
    entity
    |> cast(attrs, [:user_id, :token_id])
    |> validate_required([:user_id, :token_id])
    |> unique_constraint([:user_id, :token_id], message: @contraint_message)
  end
end

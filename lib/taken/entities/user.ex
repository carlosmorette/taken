defmodule Taken.Entities.UserEntity do
  use Ecto.Schema

  @derive {Jason.Encoder, only: [:id]}
  @primary_key {:id, :binary_id, autogenerate: :unique}

  schema "users" do
    timestamps()
  end
end

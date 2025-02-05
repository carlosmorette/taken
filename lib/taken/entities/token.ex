defmodule Taken.Entities.Token do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: :unique}

  @token_expiration_in_seconds Application.compile_env(:taken, :token_expiration_in_seconds)

  schema "tokens" do
    field :active_time, :integer, default: @token_expiration_in_seconds
    field :status, Ecto.Enum, values: [:available, :active]

    has_many :usage_history, UsageHistory

    timestamps()
  end
end

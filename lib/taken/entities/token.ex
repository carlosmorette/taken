defmodule Taken.Entities.TokenEntity do
  use Ecto.Schema
  import Ecto.Changeset

  alias Taken.Entities.UsageHistoryEntity

  @primary_key {:id, :binary_id, autogenerate: true}

  @token_expiration_in_seconds Application.compile_env(:taken, :token_expiration_in_seconds)

  schema "tokens" do
    field :active_time, :integer, default: @token_expiration_in_seconds
    field :status, Ecto.Enum, values: [:available, :active]

    has_many :usage_history, UsageHistoryEntity

    timestamps()
  end

  def update_changeset(entity, attrs) do
    cast(entity, attrs, [:status])
  end
end

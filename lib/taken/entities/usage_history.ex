defmodule Taken.Entities.UsageHistoryEntity do
  use Ecto.Schema
  import Ecto.Changeset

  @foreign_key_type :binary_id

  schema "token_usage_history" do
    belongs_to :user, UserEntity
    belongs_to :token, TokenEntity

    field :initiated_at, :naive_datetime
    field :finished_at, :naive_datetime
  end

  def create_changeset(entity \\ %__MODULE__{}, attrs) do
    entity
    |> cast(attrs, [:user_id, :token_id, :initiated_at, :finished_at])
    |> validate_required([:user_id, :token_id, :initiated_at])
  end

  def update_changeset(entity, attrs) do
    entity
    |> cast(attrs, [:finished_at])
    |> validate_required([:finished_at])
  end
end

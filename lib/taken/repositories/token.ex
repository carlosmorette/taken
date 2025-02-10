defmodule Taken.Repositories.TokenRepository do
  import Ecto.Query

  alias Taken.Repo
  alias Taken.Entities.{TokenEntity, UsageHistoryEntity}

  def find_active(user_id: user_id, token_id: token_id) do
    query =
      from t in TokenEntity,
        where: t.status == :active,
        join: uh in UsageHistoryEntity,
        on: uh.user_id == ^user_id and uh.token_id == ^token_id,
        where: is_nil(uh.finished_at),
        preload: [usage_history: uh]

    Repo.one(query)
  end

  def find(token_id: token_id) do
    query =
      from t in TokenEntity,
        where: t.id == ^token_id,
        left_join: uh in UsageHistoryEntity,
        on: uh.token_id == t.id,
        preload: [usage_history: uh]

    Repo.one(query)
  rescue
    Ecto.Query.CastError ->
      nil
  end

  def update_to_available!(%TokenEntity{} = token) do
    token
    |> TokenEntity.update_changeset(%{status: :available})
    |> Repo.update!()
  end

  def update_to_active(token_id) do
    Repo.update_all(
      (from t in TokenEntity, where: t.id == ^token_id),
      set: [status: :active]
    )
    rescue
      Ecto.Query.CastError ->
        {0, nil}
  end

  def count_active do
    query = from t in TokenEntity, where: t.status == :active
    Repo.aggregate(query, :count, :id)
  end

  def find_last_active do
    Repo.one(
      from t in TokenEntity,
        where: t.status == :active,
        order_by: [desc: t.updated_at],
        join: uh in UsageHistoryEntity,
        on: uh.user_id == t.user_id and uh.token_id == t.token_id,
        where: is_nil(uh.finished_at),
        preload: [usage_history: uh]
    )
  end

  def find_all(limit: limit, offset: offset) do
    Repo.all(
      from t in TokenEntity,
      order_by: {:desc, :inserted_at},
      limit: ^limit,
      offset: ^offset
    )
  end
end

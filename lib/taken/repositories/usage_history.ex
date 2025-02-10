defmodule Taken.Repositories.UsageHistoryRepository do
  import Ecto.Query

  alias Taken.Repo
  alias Taken.DTOs.Internal.RegisterTokenUsageDTO
  alias Taken.Entities.UsageHistoryEntity

  def insert!(%RegisterTokenUsageDTO{} = dto) do
    %{user_id: dto.user_id, token_id: dto.token_id, initiated_at: NaiveDateTime.utc_now()}
    |> UsageHistoryEntity.create_changeset()
    |> Repo.insert!()
  end

  def finish_usage!(%UsageHistoryEntity{} = entity) do
    entity
    |> UsageHistoryEntity.update_changeset(%{finished_at: NaiveDateTime.utc_now()})
    |> Repo.update!()
  end

  def find_not_finished_user_token_usage(%RegisterTokenUsageDTO{} = dto) do
    Repo.one(from u in UsageHistoryEntity, where: u.user_id == ^dto.user_id, where: is_nil(u.finished_at))
  end

  def preload_user(%UsageHistoryEntity{} = entity) do
    Repo.preload(entity, :user)
  end
end

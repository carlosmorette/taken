defmodule Taken.Mappers.UsageHistoryMapper do
  alias Taken.DTOs.External.UsageHistoryDTO
  alias Taken.Entities.UsageHistoryEntity

  def entity_to_dto(%UsageHistoryEntity{} = entity) do
    %UsageHistoryDTO{
      id: entity.id,
      initiated_at: entity.initiated_at,
      finished_at: entity.finished_at
    }
  end
end

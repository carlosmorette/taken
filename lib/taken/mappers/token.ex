defmodule Taken.Mappers.TokenMapper do
  alias Taken.Entities.UserEntity
  alias Taken.Entities.TokenEntity
  alias Taken.DTOs.External.TokenDTO

  alias Taken.Mappers.UsageHistoryMapper

  def map_entity_to_dto(%TokenEntity{} = entity) do
    %TokenDTO{
      active_time: entity.active_time,
      status: entity.status
    }
  end

  def map_active_to_dto(%TokenEntity{} = token, %UserEntity{} = user) do
    %TokenDTO{
      active_time: token.active_time,
      status: token.status,
      user: user
    }
  end

  def map_available_to_dto(%TokenEntity{} = token) do
    %TokenDTO{
      active_time: token.active_time,
      status: token.status,
      usage_history: Enum.map(token.usage_history, fn ug -> UsageHistoryMapper.entity_to_dto(ug) end)
    }
  end
end

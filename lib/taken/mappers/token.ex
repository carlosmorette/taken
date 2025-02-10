defmodule Taken.Mappers.TokenMapper do
  alias Taken.Entities.TokenEntity
  alias Taken.DTOs.External.TokenDTO

  def map_entity_to_dto(%TokenEntity{} = entity) do
    %TokenDTO{
      active_time: entity.active_time,
      status: entity.status
    }
  end
end

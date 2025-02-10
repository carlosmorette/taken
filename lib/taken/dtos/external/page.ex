defmodule Taken.DTOs.External.PageDTO do
  @derive {Jason.Encoder, onyl: [:count, :limit, :offset, :data]}

  defstruct count: 0, limit: 0, offset: 0, data: []
end

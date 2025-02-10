defmodule Taken.DTOs.External.TokenDTO do
  @derive {Jason.Encoder, only: [:active_time, :status]}

  defstruct active_time: 0, status: nil
end

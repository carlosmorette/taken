defmodule Taken.DTOs.External.TokenDTO do
  @derive {Jason.Encoder, only: [:active_time, :status, :user, :usage_history]}

  defstruct active_time: 0, status: nil, user: nil, usage_history: nil
end

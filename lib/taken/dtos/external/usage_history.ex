defmodule Taken.DTOs.External.UsageHistoryDTO do
  @derive {Jason.Encoder, only: [:id, :initiated_at, :finished_at]}

  defstruct id: nil, initiated_at: nil, finished_at: nil
end

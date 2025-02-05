defmodule Taken.DTOs.External.ErrorDTO do
  @derive {Jason.Encoder, only: [:message, :details]}
  defstruct [message: nil, details: %{}]
end

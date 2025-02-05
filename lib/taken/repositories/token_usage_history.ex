defmodule Taken.Repositories.TokenUsageHistoryRepository do
  alias Taken.Repo
  alias Taken.Dtos.Internal.RegisterTokenUsageDTO

  def insert!(%RegisterTokenUsageDTO{} = dto) do
    Repo.insert!(%{
      token_id: dto.token_id,
      user_id: dto.user_id
    })
  end
end

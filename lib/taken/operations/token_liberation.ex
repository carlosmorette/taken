defmodule Taken.Operations.TokenLiberationOperation do
  alias Taken.Entities.TokenEntity
  alias Taken.Repositories.{TokenRepository, UsageHistoryRepository}

  def run(%TokenEntity{} = token) do
    Taken.Repo.transaction(fn ->
      usage_history = List.first(token.usage_history)

      TokenRepository.update_to_available!(token)
      UsageHistoryRepository.finish_usage!(usage_history)
      :ok
    end)
  end

  def run(%{user_id: user_id, token_id: token_id}) do
    Taken.Repo.transaction(fn ->
      token = TokenRepository.find_active(user_id: user_id, token_id: token_id)
      usage_history = List.first(token.usage_history)

      TokenRepository.update_to_available!(token)
      UsageHistoryRepository.finish_usage!(usage_history)
      :ok
    end)
  end
end

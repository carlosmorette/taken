defmodule Taken.Repositories.CacheRepository do
  use GenServer

  def start_link(_init_args) do
    GenServer.start_link(__MODULE__, %{conn: nil}, name: __MODULE__)
  end

  def init(_args) do
    config = Application.get_env(:taken, __MODULE__)
    host = Keyword.fetch!(config, :host)
    port = Keyword.fetch!(config, :port)

    {:ok, conn} =
      Redix.start_link(
        host: host,
        port: port
      )
  end

  ## Public API
  def increment_active_tokens() do
    GenServer.call(__MODULE__, :increment_active_tokens)
  end

  def get_active_tokens_count() do
    GenServer.call(__MODULE__, :get_active_tokens_count)
  end

  ## Server
  def handle_call(:increment_active_tokens, _from, %{conn: conn}) do
    Redix.command(conn, ["INCR", "tokens_usage"])
  end

  def handle_call(:get_active_tokens_count, _from, %{conn: conn}) do
    Redix.command(conn, ["GET", "tokens_usage"])
  end
end

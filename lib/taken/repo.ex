defmodule Taken.Repo do
  use Ecto.Repo,
    otp_app: :taken,
    adapter: Ecto.Adapters.Postgres
end

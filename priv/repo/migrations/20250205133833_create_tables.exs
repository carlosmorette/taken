defmodule Taken.Repo.Migrations.CreateTables do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true

      timestamps()
    end

    create table(:tokens, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :active_time, :integer
      add :status, :string

      timestamps()
    end

    create table(:token_usage_history) do
      add :user_id, references(:users, type: :uuid)
      add :token_id, references(:tokens, type: :uuid)

      add :initiated_at, :naive_datetime
      add :finished_at, :naive_datetime
    end

    execute("
     CREATE UNIQUE INDEX idx_unique_active_token_usage
    ON token_usage_history (user_id, token_id)
    WHERE finished_at IS NULL;
    ")
  end
end

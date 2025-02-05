# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Taken.Repo.insert!(%Taken.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


require Logger

alias Taken.Entities.TokenEntity
alias Taken.Entities.UserEntity
alias Taken.Repo

user1 = Repo.insert!(%UserEntity{id: Ecto.UUID.generate()})

Logger.info("Inserted user1: #{user1.id}")

user2 = Repo.insert!(%UserEntity{id: Ecto.UUID.generate()})

Logger.info("Inserted user2: #{user2.id}")

for _ <- 1..100 do
  Repo.insert!(%TokenEntity{status: :available})
end

defmodule LipiaNgoma.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false, size: 160
      add :username, :string, null: false
      add :verified, :boolean, null: false, default: false
      add :hashed_password, :string, null: false
      add :role, :string, null: false, default: "user"
      add :status, :string, null: false, default: "active"
      add :confirmed_at, :naive_datetime
      timestamps()
    end

    create unique_index(:users, [:email, :username])

    create table(:users_tokens) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :token, :binary, null: false, size: 32
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:users_tokens, [:user_id])
    create unique_index(:users_tokens, [:context, :token])
  end
end

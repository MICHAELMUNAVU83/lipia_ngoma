defmodule LipiaNgoma.Repo.Migrations.CreateBoosts do
  use Ecto.Migration

  def change do
    create table(:boosts) do
      add :name, :string
      add :phone_number, :string
      add :price, :integer
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :song_request_id, references(:song_requests, on_delete: :delete_all), null: false
      add :boostid, :string

      timestamps()
    end
  end
end

defmodule LipiaNgoma.Repo.Migrations.CreateSongRequests do
  use Ecto.Migration

  def change do
    create table(:song_requests) do
      add :name, :string
      add :phone_number, :string
      add :price, :integer
      add :is_played, :boolean, default: false, null: false
      add :is_refunded, :boolean, default: false, null: false
      add :songrequestid, :string
      add :song_name, :string
      add :artists, :string
      add :image, :string
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:song_requests, [:songrequestid, :user_id])
  end
end

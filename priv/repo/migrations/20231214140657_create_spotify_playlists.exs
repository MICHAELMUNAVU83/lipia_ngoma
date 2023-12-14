defmodule LipiaNgoma.Repo.Migrations.CreateSpotifyPlaylists do
  use Ecto.Migration

  def change do
    create table(:spotify_playlists) do
      add :phone_number, :string
      add :price, :integer
      add :status, :string, default: "pending"
      add :name, :string
      add :dj_id, references(:users, on_delete: :nothing)
      add :client_id, references(:users, on_delete: :nothing)
      add :spotify_playlist_link, :string

      timestamps()
    end
  end
end

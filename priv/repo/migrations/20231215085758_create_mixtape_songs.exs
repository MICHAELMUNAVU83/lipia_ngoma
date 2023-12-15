defmodule LipiaNgoma.Repo.Migrations.CreateMixtapeSongs do
  use Ecto.Migration

  def change do
    create table(:mixtape_songs) do
      add :song_name, :string
      add :image, :string
      add :artists, :string
      add :dj_id, references(:users, on_delete: :nothing)
      add :client_id, references(:users, on_delete: :nothing)
      add :mixtape_id, references(:mixtapes, on_delete: :nothing)

      timestamps()
    end
  end
end

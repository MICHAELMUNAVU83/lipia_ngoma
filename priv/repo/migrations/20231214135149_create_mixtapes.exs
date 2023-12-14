defmodule LipiaNgoma.Repo.Migrations.CreateMixtapes do
  use Ecto.Migration

  def change do
    create table(:mixtapes) do
      add :status, :string
      add :dj_id, references(:users, on_delete: :nothing)
      add :client_id, references(:users, on_delete: :nothing)

      timestamps()
    end
  end
end

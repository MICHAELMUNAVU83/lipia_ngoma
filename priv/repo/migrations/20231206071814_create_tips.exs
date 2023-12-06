defmodule LipiaNgoma.Repo.Migrations.CreateTips do
  use Ecto.Migration

  def change do
    create table(:tips) do
      add :name, :string
      add :phone_number, :string
      add :price, :integer
      add :tipid, :string
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:tips, [:tipid, :user_id])
  end
end

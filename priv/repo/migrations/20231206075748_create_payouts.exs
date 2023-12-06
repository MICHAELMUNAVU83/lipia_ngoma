defmodule LipiaNgoma.Repo.Migrations.CreatePayouts do
  use Ecto.Migration

  def change do
    create table(:payouts) do
      add :name, :string
      add :phone_number, :string
      add :amount, :integer
      add :payoutid, :string
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end
  end
end

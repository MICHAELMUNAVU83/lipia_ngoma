defmodule LipiaNgoma.Tips.Tip do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tips" do
    field :name, :string
    field :phone_number, :string
    field :price, :integer
    field :tipid, :string
    belongs_to :user, LipiaNgoma.Users.User

    timestamps()
  end

  @doc false
  def changeset(tip, attrs) do
    tip
    |> cast(attrs, [:name, :phone_number, :price, :tipid, :user_id])
    |> validate_required([:name, :phone_number, :price, :tipid, :user_id])
  end
end

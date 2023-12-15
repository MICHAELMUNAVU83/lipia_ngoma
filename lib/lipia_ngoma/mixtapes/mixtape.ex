defmodule LipiaNgoma.Mixtapes.Mixtape do
  use Ecto.Schema
  import Ecto.Changeset

  schema "mixtapes" do
    field :status, :string
    belongs_to :dj, LipiaNgoma.Users.User
    belongs_to :client, LipiaNgoma.Users.User
    has_many :mixtape_songs, LipiaNgoma.MixtapeSongs.MixtapeSong
    field :name, :string
    field :phone_number, :string
    field :mixtape_name, :string
    field :price, :integer

    timestamps()
  end

  @doc false
  def changeset(mixtape, attrs) do
    mixtape
    |> cast(attrs, [:status, :dj_id, :client_id])
    |> validate_required([:status, :dj_id, :client_id])
  end

  def payment_changeset(mixtape, attrs) do
    mixtape
    |> cast(attrs, [:status, :dj_id, :client_id, :name, :phone_number, :mixtape_name, :price])
    |> validate_required([
      :status,
      :dj_id,
      :client_id,
      :name,
      :phone_number,
      :mixtape_name,
      :price
    ])
  end
end

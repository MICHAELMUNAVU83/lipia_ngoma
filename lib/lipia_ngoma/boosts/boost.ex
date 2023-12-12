defmodule LipiaNgoma.Boosts.Boost do
  use Ecto.Schema
  import Ecto.Changeset

  schema "boosts" do
    field :name, :string
    field :phone_number, :string
    field :price, :integer
    field :boostid, :string
    belongs_to :user, LipiaNgoma.Users.User
    belongs_to :song_request, LipiaNgoma.SongRequests.SongRequest

    timestamps()
  end

  @doc false
  def changeset(boost, attrs) do
    boost
    |> cast(attrs, [:name, :phone_number, :price, :boostid, :user_id, :song_request_id])
    |> validate_required([:name, :phone_number, :price, :boostid, :user_id, :song_request_id])
    |> validate_format(
      :phone_number,
      ~r/^254\d{9}$/,
      message: "Number has to start with 254 and have 12 digits"
    )
  end
end

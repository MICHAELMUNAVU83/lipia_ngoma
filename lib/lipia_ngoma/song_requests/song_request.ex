defmodule LipiaNgoma.SongRequests.SongRequest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "song_requests" do
    field :name, :string
    field :phone_number, :string
    field :price, :integer
    field :is_played, :boolean, default: false
    field :is_refunded, :boolean, default: false
    field :songrequestid, :string
    field :songname, :string
    belongs_to :user, LipiaNgoma.Users.User

    timestamps()
  end

  @doc false
  def changeset(song_request, attrs) do
    song_request
    |> cast(attrs, [
      :name,
      :phone_number,
      :price,
      :is_played,
      :is_refunded,
      :songrequestid,
      :songname,
      :user_id
    ])
    |> validate_required([
      :name,
      :phone_number,
      :price,
      :is_played,
      :is_refunded,
      :songrequestid,
      :songname,
      :user_id
    ])
  end
end

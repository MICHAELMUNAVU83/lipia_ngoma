defmodule LipiaNgoma.SpotifyPlaylists.SpotifyPlaylist do
  use Ecto.Schema
  import Ecto.Changeset

  schema "spotify_playlists" do
    field :name, :string
    field :status, :string, default: "pending"
    field :phone_number, :string
    field :spotify_playlist_link, :string
    field :mixtape_name, :string
    field :price, :integer
    belongs_to :dj, LipiaNgoma.Users.User
    belongs_to :client, LipiaNgoma.Users.User

    timestamps()
  end

  @doc false
  def changeset(spotify_playlist, attrs) do
    spotify_playlist
    |> cast(attrs, [
      :phone_number,
      :price,
      :status,
      :name,
      :dj_id,
      :client_id,
      :mixtape_name,
      :spotify_playlist_link
    ])
    |> validate_required([
      :phone_number,
      :price,
      :status,
      :name,
      :dj_id,
      :client_id,
      :mixtape_name,
      :spotify_playlist_link
    ])
  end
end

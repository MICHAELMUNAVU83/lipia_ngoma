defmodule LipiaNgoma.MixtapeSongs.MixtapeSong do
  use Ecto.Schema
  import Ecto.Changeset

  schema "mixtape_songs" do
    field :image, :string
    field :song_name, :string
    field :artists, :string
    field :songid, :string
    belongs_to :dj, LipiaNgoma.Users.User
    belongs_to :client, LipiaNgoma.Users.User
    belongs_to :mixtape, LipiaNgoma.Mixtapes.Mixtape

    timestamps()
  end

  @doc false
  def changeset(mixtape_song, attrs) do
    mixtape_song
    |> cast(attrs, [:song_name, :image, :artists, :dj_id, :client_id, :mixtape_id, :songid])
    |> validate_required([:song_name, :image, :artists, :dj_id, :client_id, :mixtape_id, :songid])
  end
end

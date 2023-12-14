defmodule LipiaNgoma.SpotifyPlaylistsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LipiaNgoma.SpotifyPlaylists` context.
  """

  @doc """
  Generate a spotify_playlist.
  """
  def spotify_playlist_fixture(attrs \\ %{}) do
    {:ok, spotify_playlist} =
      attrs
      |> Enum.into(%{
        name: "some name",
        status: "some status",
        phone_number: "some phone_number",
        price: 42
      })
      |> LipiaNgoma.SpotifyPlaylists.create_spotify_playlist()

    spotify_playlist
  end
end

defmodule LipiaNgoma.MixtapeSongsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LipiaNgoma.MixtapeSongs` context.
  """

  @doc """
  Generate a mixtape_song.
  """
  def mixtape_song_fixture(attrs \\ %{}) do
    {:ok, mixtape_song} =
      attrs
      |> Enum.into(%{
        image: "some image",
        song_name: "some song_name",
        artists: "some artists"
      })
      |> LipiaNgoma.MixtapeSongs.create_mixtape_song()

    mixtape_song
  end
end

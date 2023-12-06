defmodule LipiaNgoma.SongRequestsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LipiaNgoma.SongRequests` context.
  """

  @doc """
  Generate a song_request.
  """
  def song_request_fixture(attrs \\ %{}) do
    {:ok, song_request} =
      attrs
      |> Enum.into(%{
        name: "some name",
        phone_number: "some phone_number",
        price: "some price",
        is_played: true,
        is_refunded: true,
        songrequestid: "some songrequestid"
      })
      |> LipiaNgoma.SongRequests.create_song_request()

    song_request
  end
end

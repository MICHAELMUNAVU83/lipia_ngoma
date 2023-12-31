defmodule LipiaNgoma.Spotify do
  def initiate_search(query) do
    header = header()

    query = String.replace(query, " ", "%20")

    url =
      "https://api.spotify.com/v1/search?q=#{query}&type=album%2Cartist%2Ctrack"

    case HTTPoison.get(url, header, []) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        tracks =
          body
          |> Jason.decode!()

        tracks["tracks"]["items"]
    end
  end

  def get_bearer_token do
    url = "https://accounts.spotify.com/api/token"

    header = [
      {
        "Content-Type",
        "application/x-www-form-urlencoded"
      }
    ]

    body =
      %{
        "grant_type" => "client_credentials",
        "client_id" => "81a20f80ffd2484581aa78bb2ca0ed70",
        "client_secret" => "8328ca3f7ca94353add9ea1117e2c3b6"
      }
      |> URI.encode_query()

    case HTTPoison.post(url, body, header) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        token =
          body
          |> Jason.decode!()

        token["access_token"]
    end
  end

  def get_track(track_id) do
    header = header()

    url =
      "https://api.spotify.com/v1/tracks/#{track_id}"

    case HTTPoison.get(url, header, []) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        tracks =
          body
          |> Jason.decode!()

        tracks
    end
  end

  def get_playlist(playlist_id) do
    header = header()

    url =
      "https://api.spotify.com/v1/playlists/#{playlist_id}/tracks"

    case HTTPoison.get(url, header, []) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        tracks =
          body
          |> Jason.decode!()

        tracks
    end
  end

  defp header do
    [
      {
        "Authorization",
        "Bearer BQDFR2eaIN-lAA9rOu-9KZeZYdfgde5_-eX9dex74kJYeun-HeIUGSuQjzxTxRq8bQo8erfvfiqorUzvmZFMsSG0-AjQa0TBRCFP9JY6I5SXJy-rhaM"
      }
    ]
  end
end

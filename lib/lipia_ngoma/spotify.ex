defmodule LipiaNgoma.Spotify do
  def initiate_search(query) do
    header = header()

    url =
      "https://spotify23.p.rapidapi.com/search/?q=#{query}&type=multi&offset=0&limit=10&numberOfTopResults=5"

    case HTTPoison.get(url, header, []) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        tracks =
          body
          |> Jason.decode!()

        tracks["tracks"]["items"]
    end
  end

  def get_track(track_id) do
    header = header()

    url =
      "https://spotify23.p.rapidapi.com/tracks/?ids=#{track_id}"

    case HTTPoison.get(url, header, []) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        tracks =
          body
          |> Jason.decode!()

        tracks["tracks"]
        |> List.first()
    end
  end

  defp header do
    [
      {
        "X-RapidAPI-Key",
        "6261efeb47msh97697eec925d06bp12ceabjsnc6953baa6b9d"
      },
      {
        "X-RapidAPI-Host",
        "spotify23.p.rapidapi.com"
      }
    ]
  end
end

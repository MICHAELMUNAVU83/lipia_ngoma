defmodule LipiaNgoma.SpotifyPlaylists do
  @moduledoc """
  The SpotifyPlaylists context.
  """

  import Ecto.Query, warn: false
  alias LipiaNgoma.Repo

  alias LipiaNgoma.SpotifyPlaylists.SpotifyPlaylist

  @doc """
  Returns the list of spotify_playlists.

  ## Examples

      iex> list_spotify_playlists()
      [%SpotifyPlaylist{}, ...]

  """
  def list_spotify_playlists do
    Repo.all(SpotifyPlaylist)
  end

  @doc """
  Gets a single spotify_playlist.

  Raises `Ecto.NoResultsError` if the Spotify playlist does not exist.

  ## Examples

      iex> get_spotify_playlist!(123)
      %SpotifyPlaylist{}

      iex> get_spotify_playlist!(456)
      ** (Ecto.NoResultsError)

  """
  def get_spotify_playlist!(id), do: Repo.get!(SpotifyPlaylist, id)

  @doc """
  Creates a spotify_playlist.

  ## Examples

      iex> create_spotify_playlist(%{field: value})
      {:ok, %SpotifyPlaylist{}}

      iex> create_spotify_playlist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_spotify_playlist(attrs \\ %{}) do
    %SpotifyPlaylist{}
    |> SpotifyPlaylist.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a spotify_playlist.

  ## Examples

      iex> update_spotify_playlist(spotify_playlist, %{field: new_value})
      {:ok, %SpotifyPlaylist{}}

      iex> update_spotify_playlist(spotify_playlist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_spotify_playlist(%SpotifyPlaylist{} = spotify_playlist, attrs) do
    spotify_playlist
    |> SpotifyPlaylist.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a spotify_playlist.

  ## Examples

      iex> delete_spotify_playlist(spotify_playlist)
      {:ok, %SpotifyPlaylist{}}

      iex> delete_spotify_playlist(spotify_playlist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_spotify_playlist(%SpotifyPlaylist{} = spotify_playlist) do
    Repo.delete(spotify_playlist)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking spotify_playlist changes.

  ## Examples

      iex> change_spotify_playlist(spotify_playlist)
      %Ecto.Changeset{data: %SpotifyPlaylist{}}

  """
  def change_spotify_playlist(%SpotifyPlaylist{} = spotify_playlist, attrs \\ %{}) do
    SpotifyPlaylist.changeset(spotify_playlist, attrs)
  end
end

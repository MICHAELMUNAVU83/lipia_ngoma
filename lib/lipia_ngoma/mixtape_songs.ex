defmodule LipiaNgoma.MixtapeSongs do
  @moduledoc """
  The MixtapeSongs context.
  """

  import Ecto.Query, warn: false
  alias LipiaNgoma.Repo

  alias LipiaNgoma.MixtapeSongs.MixtapeSong

  @doc """
  Returns the list of mixtape_songs.

  ## Examples

      iex> list_mixtape_songs()
      [%MixtapeSong{}, ...]

  """
  def list_mixtape_songs do
    Repo.all(MixtapeSong)
  end

  @doc """
  Gets a single mixtape_song.

  Raises `Ecto.NoResultsError` if the Mixtape song does not exist.

  ## Examples

      iex> get_mixtape_song!(123)
      %MixtapeSong{}

      iex> get_mixtape_song!(456)
      ** (Ecto.NoResultsError)

  """
  def get_mixtape_song!(id), do: Repo.get!(MixtapeSong, id)

  @doc """
  Creates a mixtape_song.

  ## Examples

      iex> create_mixtape_song(%{field: value})
      {:ok, %MixtapeSong{}}

      iex> create_mixtape_song(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_mixtape_song(attrs \\ %{}) do
    %MixtapeSong{}
    |> MixtapeSong.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a mixtape_song.

  ## Examples

      iex> update_mixtape_song(mixtape_song, %{field: new_value})
      {:ok, %MixtapeSong{}}

      iex> update_mixtape_song(mixtape_song, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_mixtape_song(%MixtapeSong{} = mixtape_song, attrs) do
    mixtape_song
    |> MixtapeSong.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a mixtape_song.

  ## Examples

      iex> delete_mixtape_song(mixtape_song)
      {:ok, %MixtapeSong{}}

      iex> delete_mixtape_song(mixtape_song)
      {:error, %Ecto.Changeset{}}

  """
  def delete_mixtape_song(%MixtapeSong{} = mixtape_song) do
    Repo.delete(mixtape_song)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking mixtape_song changes.

  ## Examples

      iex> change_mixtape_song(mixtape_song)
      %Ecto.Changeset{data: %MixtapeSong{}}

  """
  def change_mixtape_song(%MixtapeSong{} = mixtape_song, attrs \\ %{}) do
    MixtapeSong.changeset(mixtape_song, attrs)
  end
end

defmodule LipiaNgoma.Boosts do
  @moduledoc """
  The Boosts context.
  """

  import Ecto.Query, warn: false
  alias LipiaNgoma.Repo

  alias LipiaNgoma.Boosts.Boost

  @doc """
  Returns the list of boosts.

  ## Examples

      iex> list_boosts()
      [%Boost{}, ...]

  """
  def list_boosts do
    Repo.all(Boost)
  end

  @doc """
  Gets a single boost.

  Raises `Ecto.NoResultsError` if the Boost does not exist.

  ## Examples

      iex> get_boost!(123)
      %Boost{}

      iex> get_boost!(456)
      ** (Ecto.NoResultsError)

  """
  def get_boost!(id), do: Repo.get!(Boost, id) |> Repo.preload(:song_request)

  @doc """
  Creates a boost.

  ## Examples

      iex> create_boost(%{field: value})
      {:ok, %Boost{}}

      iex> create_boost(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_boost(attrs \\ %{}) do
    %Boost{}
    |> Boost.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a boost.

  ## Examples

      iex> update_boost(boost, %{field: new_value})
      {:ok, %Boost{}}

      iex> update_boost(boost, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_boost(%Boost{} = boost, attrs) do
    boost
    |> Boost.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a boost.

  ## Examples

      iex> delete_boost(boost)
      {:ok, %Boost{}}

      iex> delete_boost(boost)
      {:error, %Ecto.Changeset{}}

  """
  def delete_boost(%Boost{} = boost) do
    Repo.delete(boost)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking boost changes.

  ## Examples

      iex> change_boost(boost)
      %Ecto.Changeset{data: %Boost{}}

  """
  def change_boost(%Boost{} = boost, attrs \\ %{}) do
    Boost.changeset(boost, attrs)
  end
end

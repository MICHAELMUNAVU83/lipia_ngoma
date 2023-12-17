defmodule LipiaNgoma.Mixtapes do
  @moduledoc """
  The Mixtapes context.
  """

  import Ecto.Query, warn: false
  alias LipiaNgoma.Repo

  alias LipiaNgoma.Mixtapes.Mixtape

  @doc """
  Returns the list of mixtapes.

  ## Examples

      iex> list_mixtapes()
      [%Mixtape{}, ...]

  """
  def list_mixtapes do
    Repo.all(Mixtape)
  end

  def get_mixtapes_for_a_user(client_id) do
    Repo.all(from(m in Mixtape, where: m.client_id == ^client_id))
  end

  def get_mixtapes_for_a_dj(dj_id) do
    Repo.all(from(m in Mixtape, where: m.dj_id == ^dj_id))
  end

  def get_mixtape_money_for_a_dj(id) do
    Repo.one(
      from m in Mixtape,
        where: m.dj_id == ^id,
        select: coalesce(sum(m.price), 0)
    )
  end

  @doc """
  Gets a single mixtape.

  Raises `Ecto.NoResultsError` if the Mixtape does not exist.

  ## Examples

      iex> get_mixtape!(123)
      %Mixtape{}

      iex> get_mixtape!(456)
      ** (Ecto.NoResultsError)

  """
  def get_mixtape!(id), do: Repo.get!(Mixtape, id) |> Repo.preload(:mixtape_songs)

  @doc """
  Creates a mixtape.

  ## Examples

      iex> create_mixtape(%{field: value})
      {:ok, %Mixtape{}}

      iex> create_mixtape(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_mixtape(attrs \\ %{}) do
    %Mixtape{}
    |> Mixtape.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a mixtape.

  ## Examples

      iex> update_mixtape(mixtape, %{field: new_value})
      {:ok, %Mixtape{}}

      iex> update_mixtape(mixtape, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_mixtape(%Mixtape{} = mixtape, attrs) do
    mixtape
    |> Mixtape.changeset(attrs)
    |> Repo.update()
  end

  def update_payment_mixtape(%Mixtape{} = mixtape, attrs) do
    mixtape
    |> Mixtape.payment_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a mixtape.

  ## Examples

      iex> delete_mixtape(mixtape)
      {:ok, %Mixtape{}}

      iex> delete_mixtape(mixtape)
      {:error, %Ecto.Changeset{}}

  """
  def delete_mixtape(%Mixtape{} = mixtape) do
    Repo.delete(mixtape)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking mixtape changes.

  ## Examples

      iex> change_mixtape(mixtape)
      %Ecto.Changeset{data: %Mixtape{}}

  """
  def change_mixtape(%Mixtape{} = mixtape, attrs \\ %{}) do
    Mixtape.changeset(mixtape, attrs)
  end

  def change_payment_mixtape(%Mixtape{} = mixtape, attrs \\ %{}) do
    Mixtape.payment_changeset(mixtape, attrs)
  end
end

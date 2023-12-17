defmodule LipiaNgoma.Payouts do
  @moduledoc """
  The Payouts context.
  """

  import Ecto.Query, warn: false
  alias LipiaNgoma.Repo

  alias LipiaNgoma.Payouts.Payout

  @doc """
  Returns the list of payouts.

  ## Examples

      iex> list_payouts()
      [%Payout{}, ...]

  """
  def list_payouts do
    Repo.all(Payout)
  end

  def list_payouts_for_a_user(id) do
    Repo.all(from p in Payout, where: p.user_id == ^id)
  end

  def get_money_withdrawn_by_a_dj(id) do
    Repo.one(
      from p in Payout,
        where: p.user_id == ^id,
        select: coalesce(sum(p.amount), 0)
    )
  end

  @doc """
  Gets a single payout.

  Raises `Ecto.NoResultsError` if the Payout does not exist.

  ## Examples

      iex> get_payout!(123)
      %Payout{}

      iex> get_payout!(456)
      ** (Ecto.NoResultsError)

  """
  def get_payout!(id), do: Repo.get!(Payout, id)

  @doc """
  Creates a payout.

  ## Examples

      iex> create_payout(%{field: value})
      {:ok, %Payout{}}

      iex> create_payout(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_payout(attrs \\ %{}) do
    %Payout{}
    |> Payout.changeset(attrs)
    |> Repo.insert()
  end

  def create_dj_payment(attrs \\ %{}, user_id) do
    %Payout{}
    |> Payout.payout_changeset(attrs, user_id)
    |> Repo.insert()
  end

  @doc """
  Updates a payout.

  ## Examples

      iex> update_payout(payout, %{field: new_value})
      {:ok, %Payout{}}

      iex> update_payout(payout, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_payout(%Payout{} = payout, attrs) do
    payout
    |> Payout.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a payout.

  ## Examples

      iex> delete_payout(payout)
      {:ok, %Payout{}}

      iex> delete_payout(payout)
      {:error, %Ecto.Changeset{}}

  """
  def delete_payout(%Payout{} = payout) do
    Repo.delete(payout)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking payout changes.

  ## Examples

      iex> change_payout(payout)
      %Ecto.Changeset{data: %Payout{}}

  """
  def change_payout(%Payout{} = payout, attrs \\ %{}) do
    Payout.changeset(payout, attrs)
  end
end

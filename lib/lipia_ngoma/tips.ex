defmodule LipiaNgoma.Tips do
  @moduledoc """
  The Tips context.
  """

  import Ecto.Query, warn: false
  alias LipiaNgoma.Repo

  alias LipiaNgoma.Tips.Tip

  @doc """
  Returns the list of tips.

  ## Examples

      iex> list_tips()
      [%Tip{}, ...]

  """
  def list_tips do
    Repo.all(Tip)
  end

  def list_tips_for_a_user(id) do
    Repo.all(from t in Tip, where: t.user_id == ^id)
  end

  def search_tips(query, id) do
    if query == "" || query == nil do
      list_tips_for_a_user(id)
    else
      list_tips_for_a_user(id)
      |> Enum.filter(fn tip ->
        String.contains?(String.downcase(tip.name), String.downcase(query)) or
          String.contains?(
            String.downcase(tip.phone_number),
            String.downcase(query)
          )
      end)
    end
  end

  @doc """
  Gets a single tip.

  Raises `Ecto.NoResultsError` if the Tip does not exist.

  ## Examples

      iex> get_tip!(123)
      %Tip{}

      iex> get_tip!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tip!(id), do: Repo.get!(Tip, id)

  @doc """
  Creates a tip.

  ## Examples

      iex> create_tip(%{field: value})
      {:ok, %Tip{}}

      iex> create_tip(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tip(attrs \\ %{}) do
    %Tip{}
    |> Tip.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tip.

  ## Examples

      iex> update_tip(tip, %{field: new_value})
      {:ok, %Tip{}}

      iex> update_tip(tip, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tip(%Tip{} = tip, attrs) do
    tip
    |> Tip.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tip.

  ## Examples

      iex> delete_tip(tip)
      {:ok, %Tip{}}

      iex> delete_tip(tip)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tip(%Tip{} = tip) do
    Repo.delete(tip)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tip changes.

  ## Examples

      iex> change_tip(tip)
      %Ecto.Changeset{data: %Tip{}}

  """
  def change_tip(%Tip{} = tip, attrs \\ %{}) do
    Tip.changeset(tip, attrs)
  end
end

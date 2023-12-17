defmodule LipiaNgoma.SongRequests do
  @moduledoc """
  The SongRequests context.
  """

  import Ecto.Query, warn: false
  alias LipiaNgoma.Repo

  alias LipiaNgoma.SongRequests.SongRequest

  @doc """
  Returns the list of song_requests.

  ## Examples

      iex> list_song_requests()
      [%SongRequest{}, ...]

  """
  def list_song_requests do
    Repo.all(SongRequest)
  end

  def list_song_requests_for_a_user(id) do
    Repo.all(from s in SongRequest, where: s.user_id == ^id, order_by: [desc: s.price])
    |> Enum.filter(fn song_request -> song_request.is_played == false end)
    |> Enum.filter(fn song_request -> song_request.is_refunded == false end)
  end

  def get_total_song_request_money_for_a_user(id) do
    Repo.one(
      from s in SongRequest,
        where: s.user_id == ^id,
        where: s.is_played == true and s.is_refunded == false,
        select: coalesce(sum(s.price), 0)
    )
  end

  def get_eventual_song_position(amount, id) do
    array =
      list_song_requests_for_a_user(id)
      |> Enum.map(fn song_request -> song_request.price end)

    new_array =
      [amount | array]
      |> Enum.sort(:desc)

    zero_index = Enum.find_index(new_array, fn x -> x == amount end)
    index = zero_index + 1
  end

  def get_song_position(song_id, user_id) do
    array =
      list_song_requests_for_a_user(user_id)

    zero_index = Enum.find_index(array, fn x -> x.id == song_id end)

    index = zero_index + 1
  end

  @doc """
  Gets a single song_request.

  Raises `Ecto.NoResultsError` if the Song request does not exist.

  ## Examples

      iex> get_song_request!(123)
      %SongRequest{}

      iex> get_song_request!(456)
      ** (Ecto.NoResultsError)

  """
  def get_song_request!(id), do: Repo.get!(SongRequest, id)

  @doc """
  Creates a song_request.

  ## Examples

      iex> create_song_request(%{field: value})
      {:ok, %SongRequest{}}

      iex> create_song_request(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_song_request(attrs \\ %{}) do
    %SongRequest{}
    |> SongRequest.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a song_request.

  ## Examples

      iex> update_song_request(song_request, %{field: new_value})
      {:ok, %SongRequest{}}

      iex> update_song_request(song_request, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_song_request(%SongRequest{} = song_request, attrs) do
    song_request
    |> SongRequest.changeset(attrs)
    |> Repo.update()
  end

  def search(query, id) do
    if query == "" || query == nil do
      list_song_requests_for_a_user(id)
    else
      list_song_requests_for_a_user(id)
      |> Enum.filter(fn song ->
        String.contains?(String.downcase(song.song_name), String.downcase(query)) or
          String.contains?(
            String.downcase(song.artists),
            String.downcase(query)
          )
      end)
    end
  end

  @doc """
  Deletes a song_request.

  ## Examples

      iex> delete_song_request(song_request)
      {:ok, %SongRequest{}}

      iex> delete_song_request(song_request)
      {:error, %Ecto.Changeset{}}

  """
  def delete_song_request(%SongRequest{} = song_request) do
    Repo.delete(song_request)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking song_request changes.

  ## Examples

      iex> change_song_request(song_request)
      %Ecto.Changeset{data: %SongRequest{}}

  """
  def change_song_request(%SongRequest{} = song_request, attrs \\ %{}) do
    SongRequest.changeset(song_request, attrs)
  end
end

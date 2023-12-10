defmodule LipiaNgomaWeb.BoostLive.Index do
  use LipiaNgomaWeb, :live_view

  alias LipiaNgoma.Boosts
  alias LipiaNgoma.Boosts.Boost
  alias LipiaNgoma.Users
  alias LipiaNgoma.SongRequests.SongRequest
  alias LipiaNgoma.SongRequests

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, %{
         "username" => username,
         "song_request_id" => song_request_id
       }) do
    user = Users.get_user_by_username(username)
    song_request = SongRequests.get_song_request!(song_request_id)

    socket
    |> assign(:user, user)
    |> assign(:song_request, song_request)
    |> assign(:boost, %Boost{})
    |> assign(:changeset, Boosts.change_boost(%Boost{}))
    |> assign(:page_title, "Add A boost for #{song_request.name} ")
  end

  def handle_event("validate", %{"boost" => boost_params}, socket) do
    changeset =
      socket.assigns.boost
      |> Boosts.change_boost(boost_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"boost" => boost_params}, socket) do
    new_boost_params =
      boost_params
      |> Map.put("song_request_id", socket.assigns.song_request.id)
      |> Map.put("boostid", "etg")

    case Boosts.create_boost(new_boost_params) do
      {:ok, _boost} ->
        {:noreply,
         socket
         |> put_flash(:info, "Boost created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  @impl true

  defp list_boosts do
    Boosts.list_boosts()
  end
end

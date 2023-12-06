defmodule LipiaNgomaWeb.SongRequestLive.Index do
  use LipiaNgomaWeb, :live_view

  alias LipiaNgoma.SongRequests
  alias LipiaNgoma.Users
  alias LipiaNgoma.SongRequests.SongRequest

  @impl true
  def mount(_params, session, socket) do
    current_user = Users.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> assign(:current_user, current_user)
     |> assign(:song_requests, list_song_requests(current_user.id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Song request")
    |> assign(:song_request, SongRequests.get_song_request!(id))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Song requests")
    |> assign(:song_request, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    song_request = SongRequests.get_song_request!(id)
    {:ok, _} = SongRequests.delete_song_request(song_request)

    {:noreply, assign(socket, :song_requests, list_song_requests(socket.assigns.current_user.id))}
  end

  defp list_song_requests(id) do
    SongRequests.list_song_requests_for_a_user(id)
  end
end

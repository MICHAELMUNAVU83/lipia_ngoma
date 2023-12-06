defmodule LipiaNgomaWeb.PageLive.SongRequests do
  use LipiaNgomaWeb, :live_view
  alias LipiaNgoma.Users
  alias LipiaNgoma.ClubOfTheDays
  alias LipiaNgoma.SongRequests.SongRequest
  alias LipiaNgoma.SongRequests

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, %{"username" => username}) do
    user = Users.get_user_by_username(username)

    song_requests_for_user = SongRequests.list_song_requests_for_a_user(user.id)

    socket
    |> assign(:user, user)
    |> assign(:song_requests_for_user, song_requests_for_user)
    |> assign(:page_title, "Add Song Requests for #{username} Home Page")
  end

  defp apply_action(socket, :new, %{"username" => username}) do
    user = Users.get_user_by_username(username)

    song_requests_for_user = SongRequests.list_song_requests_for_a_user(user.id)

    socket
    |> assign(:user, user)
    |> assign(:song_requests_for_user, song_requests_for_user)
    |> assign(:song_request, %SongRequest{})
    |> assign(:page_title, "Add Song Requests for #{username} Home Page")
  end
end

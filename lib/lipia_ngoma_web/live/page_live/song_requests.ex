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

    socket
    |> assign(:user, user)
    |> assign(:song_request, %SongRequest{})
    |> assign(
      :return_to,
      Routes.page_song_requests_success_path(socket, :index, user.username)
    )
    |> assign(:changeset, SongRequests.change_song_request(%SongRequest{}))
    |> assign(:page_title, "Add Song Requests for #{username} Home Page")
  end

  def handle_event("validate", %{"song_request" => song_request_params}, socket) do
    changeset =
      socket.assigns.song_request
      |> SongRequests.change_song_request(song_request_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"song_request" => song_request_params}, socket) do
    case SongRequests.create_song_request(song_request_params) do
      {:ok, _song_request} ->
        {:noreply,
         socket
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

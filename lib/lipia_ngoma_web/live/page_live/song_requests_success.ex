defmodule LipiaNgomaWeb.PageLive.SongRequestsSuccess do
  use LipiaNgomaWeb, :live_view
  alias LipiaNgoma.Users
  alias LipiaNgoma.SongRequests

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, %{
         "username" => username,
         "song_request_id" => song_request_id
       }) do
    user = Users.get_user_by_username(username)

    position = SongRequests.get_song_position(String.to_integer(song_request_id), user.id)

    song_request = SongRequests.get_song_request!(song_request_id)



    socket
    |> assign(:user, user)
    |> assign(:song_request_id, song_request_id)
    |> assign(:song_request, song_request)
    |> assign(:position, position)
    |> assign(:page_title, "Success Tip for #{username} ")
  end
end

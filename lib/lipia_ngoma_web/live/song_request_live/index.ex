defmodule LipiaNgomaWeb.SongRequestLive.Index do
  use LipiaNgomaWeb, :live_view

  alias LipiaNgoma.SongRequests
  alias LipiaNgoma.Users
  alias LipiaNgoma.SongRequests.SongRequest

  @impl true
  def mount(_params, session, socket) do
    {:ok, socket |> assign(:changeset, SongRequests.change_song_request(%SongRequest{}))}
  end

  @impl true

  def handle_params(params, _, socket) do
    user = Users.get_user_by_username(params["username"])

    songs =
      if params["q"] do
        SongRequests.search(params["q"], user.id)
      else
        SongRequests.list_song_requests_for_a_user(user.id)
      end

    {:noreply,
     socket
     |> assign(:username, params["username"])
     |> assign(:user, user)
     |> assign(:songs, songs)
     |> assign(:page_title, "SongRequests for #{params["username"]}")}
  end

  def handle_event("search_song", params, socket) do
    {:noreply,
     socket
     |> push_patch(
       to: "/#{socket.assigns.username}/song_requests/?q=#{params["song_request"]["search"]}"
     )}
  end
end

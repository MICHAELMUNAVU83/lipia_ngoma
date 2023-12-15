defmodule LipiaNgomaWeb.SongLive.Index do
  use LipiaNgomaWeb, :live_view

  alias LipiaNgoma.Tips
  alias LipiaNgoma.Users
  alias LipiaNgoma.Tips.Tip
  alias LipiaNgoma.Spotify
  alias LipiaNgoma.SongRequests
  alias LipiaNgoma.SongRequests.SongRequest

  @impl true
  def mount(_params, session, socket) do
    {:ok,
     socket
     |> assign(:changeset, SongRequests.change_song_request(%SongRequest{}))}
  end

  @impl true

  def handle_params(params, _, socket) do
    songs =
      if params["q"] do
        Spotify.initiate_search(params["q"])
      else
        Spotify.initiate_search("hiphop")
      end

    user = Users.get_user_by_username(params["username"])

    {:noreply,
     socket
     |> assign(:username, params["username"])
     |> assign(:user, user)
     |> assign(:songs, songs)
     |> assign(:page_title, "Songs")}
  end

  def handle_event("search_song", params, socket) do
    {:noreply,
     socket
     |> push_patch(to: "/#{socket.assigns.username}/songs/?q=#{params["song_request"]["search"]}")}
  end

  def handle_event("select_song", params, socket) do
    song_requests =
      SongRequests.list_song_requests_for_a_user(socket.assigns.user.id)
      |> Enum.map(fn song_request ->
        song_request.songrequestid
      end)

    case Enum.member?(song_requests, params["id"]) do
      true ->
        {:noreply,
         socket
         |> put_flash(:info, "Song already requested")}

      false ->
        {:noreply,
         socket
         |> push_redirect(
           to:
             Routes.page_song_requests_path(
               LipiaNgomaWeb.Endpoint,
               :index,
               socket.assigns.user.username,
               params["id"]
             )
         )}
    end
  end
end

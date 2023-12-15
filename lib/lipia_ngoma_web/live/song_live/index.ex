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
    IO.inspect(user)

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
end

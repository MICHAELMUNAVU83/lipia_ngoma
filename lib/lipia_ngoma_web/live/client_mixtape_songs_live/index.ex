defmodule LipiaNgomaWeb.ClientMixtapeSongsLive.Index do
  use LipiaNgomaWeb, :live_view

  alias LipiaNgoma.Users

  alias LipiaNgoma.Spotify

  alias LipiaNgoma.Mixtapes
  alias LipiaNgoma.Mixtapes.Mixtape

  @impl true
  def mount(_params, session, socket) do
    current_user = Users.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> assign(:current_user, current_user)
     |> assign(:search, "")
     |> assign(:changeset, Mixtapes.change_mixtape(%Mixtape{}))}
  end

  @impl true

  def handle_params(params, _, socket) do
    songs =
      if params["q"] do
        Spotify.initiate_search(params["q"])
      else
        Spotify.initiate_search("hiphop")
        |> Enum.take(5)
      end

    user = Users.get_user_by_username(params["username"])
    mixtape = Mixtapes.get_mixtape!(params["mixtape_id"])

    {:noreply,
     socket
     |> assign(:username, params["username"])
     |> assign(:search, params["q"])
     |> assign(:mixtape, mixtape)
     |> assign(:user, user)
     |> assign(:songs, songs)
     |> assign(:page_title, "Songs")}
  end

  def handle_event("search_song", params, socket) do
    {:noreply,
     socket
     |> push_patch(
       to:
         "/#{socket.assigns.username}/mixtape_songs/#{socket.assigns.mixtape.id}/?q=#{params["mixtape"]["search"]}"
     )}
  end
end

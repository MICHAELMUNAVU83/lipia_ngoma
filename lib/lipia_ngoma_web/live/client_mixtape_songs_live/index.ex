defmodule LipiaNgomaWeb.ClientMixtapeSongsLive.Index do
  use LipiaNgomaWeb, :live_view

  alias LipiaNgoma.Users

  alias LipiaNgoma.Spotify

  alias LipiaNgoma.Mixtapes
  alias LipiaNgoma.Mixtapes.Mixtape
  alias LipiaNgoma.MixtapeSongs
  alias LipiaNgoma.MixtapeSongs.MixtapeSong
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

  def handle_event("add_song_to_mixtape", params, socket) do
    mixtape_song_params = %{
      "song_name" => params["name"],
      "image" => params["image"],
      "artists" => params["artists"],
      "songid" => params["id"],
      "dj_id" => socket.assigns.user.id,
      "client_id" => socket.assigns.current_user.id,
      "mixtape_id" => socket.assigns.mixtape.id
    }

    {:ok, _mixtape_song} = MixtapeSongs.create_mixtape_song(mixtape_song_params)

    {:noreply,
     socket
     |> assign(:mixtape, Mixtapes.get_mixtape!(socket.assigns.mixtape.id))
     |> put_flash(:info, "#{params["name"]}  added to mixtape successfully")}
  end

  def handle_event("remove_song_from_mixtape", %{"id" => id}, socket) do
    mixtape_song = MixtapeSongs.get_mixtape_song_in_mixtape!(id, socket.assigns.mixtape.id)

    {:ok, _} = MixtapeSongs.delete_mixtape_song(mixtape_song)

    {:noreply,
     socket
     |> assign(:mixtape, Mixtapes.get_mixtape!(socket.assigns.mixtape.id))
     |> put_flash(:info, "#{mixtape_song.song_name} removed from mixtape successfully")}
  end

  def handle_event("search_song", params, socket) do
    {:noreply,
     socket
     |> push_patch(
       to:
         "/#{socket.assigns.username}/#{socket.assigns.mixtape.id}/mixtape_songs/?q=#{params["mixtape"]["search"]}"
     )}
  end
end

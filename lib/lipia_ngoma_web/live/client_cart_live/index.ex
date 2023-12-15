defmodule LipiaNgomaWeb.ClientCartLive.Index do
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
    user = Users.get_user_by_username(params["username"])

    mixtape = Mixtapes.get_mixtape!(params["mixtape_id"])

    songs =
      if params["q"] do
        MixtapeSongs.search_mixtape_songs(params["q"], mixtape.id)
      else
        mixtape.mixtape_songs
      end

    {:noreply,
     socket
     |> assign(:username, params["username"])
     |> assign(:search, params["q"])
     |> assign(:mixtape, mixtape)
     |> assign(:songs, songs)
     |> assign(:user, user)
     |> assign(:page_title, "Cart")}
  end

  def handle_event("remove_song_from_mixtape", %{"id" => id}, socket) do
    mixtape_song = MixtapeSongs.get_mixtape_song_in_mixtape!(id, socket.assigns.mixtape.id)

    case MixtapeSongs.delete_mixtape_song(mixtape_song) do
      {:ok, mixtape_song} ->
        {:noreply,
         socket
         |> assign(:songs, socket.assigns.mixtape.mixtape_songs)
         |> put_flash(:info, "#{mixtape_song.song_name} removed from mixtape")
         |> push_patch(to: "/#{socket.assigns.username}/#{socket.assigns.mixtape.id}/cart")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("search_song", params, socket) do
    {:noreply,
     socket
     |> push_patch(
       to:
         "/#{socket.assigns.username}/#{socket.assigns.mixtape.id}/cart/?q=#{params["mixtape"]["search"]}"
     )}
  end



  
end

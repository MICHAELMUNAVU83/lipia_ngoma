defmodule LipiaNgomaWeb.ClientSpotifyPlaylistLive.AddPlaylist do
  use LipiaNgomaWeb, :live_view
  alias LipiaNgoma.Users
  alias LipiaNgoma.SpotifyPlaylists
  alias LipiaNgoma.SpotifyPlaylists.SpotifyPlaylist

  def mount(_params, session, socket) do
    current_user =
      Users.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> assign(:spotify_playlist, %SpotifyPlaylist{})
     |> assign(:changeset, SpotifyPlaylists.change_spotify_playlist(%SpotifyPlaylist{}))
     |> assign(:current_user, current_user)}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, %{"username" => username}) do
    user = Users.get_user_by_username(username)

    socket
    |> assign(:page_title, "#{username} Home Page")
    |> assign(:user, user)
  end

  def handle_event("validate", %{"spotify_playlist" => spotify_playlist_params}, socket) do
    changeset =
      socket.assigns.spotify_playlist
      |> SpotifyPlaylists.change_spotify_playlist(spotify_playlist_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"spotify_playlist" => spotify_playlist_params}, socket) do
    case IO.inspect(SpotifyPlaylists.create_spotify_playlist(spotify_playlist_params)) do
      {:ok, _spotify_playlist} ->
        {:noreply,
         socket
         |> push_redirect(
           to:
             Routes.client_spotify_playlist_success_path(
               LipiaNgomaWeb.Endpoint,
               :index,
               socket.assigns.user.username
             )
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

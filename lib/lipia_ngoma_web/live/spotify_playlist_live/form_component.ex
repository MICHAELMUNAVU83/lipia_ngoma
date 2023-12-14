defmodule LipiaNgomaWeb.SpotifyPlaylistLive.FormComponent do
  use LipiaNgomaWeb, :live_component

  alias LipiaNgoma.SpotifyPlaylists

  @impl true
  def update(%{spotify_playlist: spotify_playlist} = assigns, socket) do
    changeset = SpotifyPlaylists.change_spotify_playlist(spotify_playlist)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"spotify_playlist" => spotify_playlist_params}, socket) do
    changeset =
      socket.assigns.spotify_playlist
      |> SpotifyPlaylists.change_spotify_playlist(spotify_playlist_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"spotify_playlist" => spotify_playlist_params}, socket) do
    save_spotify_playlist(socket, socket.assigns.action, spotify_playlist_params)
  end

  defp save_spotify_playlist(socket, :edit, spotify_playlist_params) do
    case SpotifyPlaylists.update_spotify_playlist(
           socket.assigns.spotify_playlist,
           spotify_playlist_params
         ) do
      {:ok, _spotify_playlist} ->
        {:noreply,
         socket
         |> put_flash(:info, "Spotify playlist updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_spotify_playlist(socket, :new, spotify_playlist_params) do
    case IO.nspect(SpotifyPlaylists.create_spotify_playlist(spotify_playlist_params)) do
      {:ok, _spotify_playlist} ->
        {:noreply,
         socket
         |> put_flash(:info, "Spotify playlist created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

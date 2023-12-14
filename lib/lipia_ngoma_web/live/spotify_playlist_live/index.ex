defmodule LipiaNgomaWeb.SpotifyPlaylistLive.Index do
  use LipiaNgomaWeb, :live_view

  alias LipiaNgoma.SpotifyPlaylists
  alias LipiaNgoma.SpotifyPlaylists.SpotifyPlaylist

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :spotify_playlists, list_spotify_playlists())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Spotify playlist")
    |> assign(:spotify_playlist, SpotifyPlaylists.get_spotify_playlist!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Spotify playlist")
    |> assign(:spotify_playlist, %SpotifyPlaylist{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Spotify playlists")
    |> assign(:spotify_playlist, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    spotify_playlist = SpotifyPlaylists.get_spotify_playlist!(id)
    {:ok, _} = SpotifyPlaylists.delete_spotify_playlist(spotify_playlist)

    {:noreply, assign(socket, :spotify_playlists, list_spotify_playlists())}
  end

  defp list_spotify_playlists do
    SpotifyPlaylists.list_spotify_playlists()
  end
end

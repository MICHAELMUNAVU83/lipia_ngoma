defmodule LipiaNgomaWeb.SpotifyPlaylistLive.Show do
  use LipiaNgomaWeb, :live_view

  alias LipiaNgoma.SpotifyPlaylists

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:spotify_playlist, SpotifyPlaylists.get_spotify_playlist!(id))}
  end

  defp page_title(:show), do: "Show Spotify playlist"
  defp page_title(:edit), do: "Edit Spotify playlist"
end

defmodule LipiaNgomaWeb.MixtapeSongLive.Show do
  use LipiaNgomaWeb, :live_view

  alias LipiaNgoma.MixtapeSongs

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:mixtape_song, MixtapeSongs.get_mixtape_song!(id))}
  end

  defp page_title(:show), do: "Show Mixtape song"
  defp page_title(:edit), do: "Edit Mixtape song"
end

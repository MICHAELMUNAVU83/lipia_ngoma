defmodule LipiaNgomaWeb.MixtapeSongLive.Index do
  use LipiaNgomaWeb, :live_view

  alias LipiaNgoma.MixtapeSongs
  alias LipiaNgoma.MixtapeSongs.MixtapeSong

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :mixtape_songs, list_mixtape_songs())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Mixtape song")
    |> assign(:mixtape_song, MixtapeSongs.get_mixtape_song!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Mixtape song")
    |> assign(:mixtape_song, %MixtapeSong{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Mixtape songs")
    |> assign(:mixtape_song, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    mixtape_song = MixtapeSongs.get_mixtape_song!(id)
    {:ok, _} = MixtapeSongs.delete_mixtape_song(mixtape_song)

    {:noreply, assign(socket, :mixtape_songs, list_mixtape_songs())}
  end

  defp list_mixtape_songs do
    MixtapeSongs.list_mixtape_songs()
  end
end

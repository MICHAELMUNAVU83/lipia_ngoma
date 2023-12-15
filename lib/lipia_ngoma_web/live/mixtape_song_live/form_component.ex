defmodule LipiaNgomaWeb.MixtapeSongLive.FormComponent do
  use LipiaNgomaWeb, :live_component

  alias LipiaNgoma.MixtapeSongs

  @impl true
  def update(%{mixtape_song: mixtape_song} = assigns, socket) do
    changeset = MixtapeSongs.change_mixtape_song(mixtape_song)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"mixtape_song" => mixtape_song_params}, socket) do
    changeset =
      socket.assigns.mixtape_song
      |> MixtapeSongs.change_mixtape_song(mixtape_song_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"mixtape_song" => mixtape_song_params}, socket) do
    save_mixtape_song(socket, socket.assigns.action, mixtape_song_params)
  end

  defp save_mixtape_song(socket, :edit, mixtape_song_params) do
    case MixtapeSongs.update_mixtape_song(socket.assigns.mixtape_song, mixtape_song_params) do
      {:ok, _mixtape_song} ->
        {:noreply,
         socket
         |> put_flash(:info, "Mixtape song updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_mixtape_song(socket, :new, mixtape_song_params) do
    case MixtapeSongs.create_mixtape_song(mixtape_song_params) do
      {:ok, _mixtape_song} ->
        {:noreply,
         socket
         |> put_flash(:info, "Mixtape song created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

defmodule LipiaNgomaWeb.SongRequestLive.FormComponent do
  use LipiaNgomaWeb, :live_component

  alias LipiaNgoma.SongRequests

  @impl true
  def update(%{song_request: song_request} = assigns, socket) do
    changeset = SongRequests.change_song_request(song_request)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"song_request" => song_request_params}, socket) do
    changeset =
      socket.assigns.song_request
      |> SongRequests.change_song_request(song_request_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"song_request" => song_request_params}, socket) do
    save_song_request(socket, socket.assigns.action, song_request_params)
  end

  defp save_song_request(socket, :edit, song_request_params) do
    case SongRequests.update_song_request(socket.assigns.song_request, song_request_params) do
      {:ok, _song_request} ->
        {:noreply,
         socket
         |> put_flash(:info, "Song request updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_song_request(socket, :new, song_request_params) do
    case SongRequests.create_song_request(song_request_params) do
      {:ok, _song_request} ->
        {:noreply,
         socket
         |> put_flash(:info, "Song request created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

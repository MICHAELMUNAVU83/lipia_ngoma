defmodule LipiaNgomaWeb.BoostLive.FormComponent do
  use LipiaNgomaWeb, :live_component

  alias LipiaNgoma.Boosts

  @impl true
  def update(%{boost: boost} = assigns, socket) do
    changeset = Boosts.change_boost(boost)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"boost" => boost_params}, socket) do
    changeset =
      socket.assigns.boost
      |> Boosts.change_boost(boost_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"boost" => boost_params}, socket) do
    save_boost(socket, socket.assigns.action, boost_params)
  end

  defp save_boost(socket, :edit, boost_params) do
    case Boosts.update_boost(socket.assigns.boost, boost_params) do
      {:ok, _boost} ->
        {:noreply,
         socket
         |> put_flash(:info, "Boost updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_boost(socket, :new, boost_params) do
    case Boosts.create_boost(boost_params) do
      {:ok, _boost} ->
        {:noreply,
         socket
         |> put_flash(:info, "Boost created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

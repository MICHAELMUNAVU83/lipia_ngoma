defmodule LipiaNgomaWeb.TipLive.FormComponent do
  use LipiaNgomaWeb, :live_component

  alias LipiaNgoma.Tips

  @impl true
  def update(%{tip: tip} = assigns, socket) do
    changeset = Tips.change_tip(tip)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"tip" => tip_params}, socket) do
    changeset =
      socket.assigns.tip
      |> Tips.change_tip(tip_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"tip" => tip_params}, socket) do
    save_tip(socket, socket.assigns.action, tip_params)
  end

  defp save_tip(socket, :edit, tip_params) do
    case Tips.update_tip(socket.assigns.tip, tip_params) do
      {:ok, _tip} ->
        {:noreply,
         socket
         |> put_flash(:info, "Tip updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_tip(socket, :new, tip_params) do
    case Tips.create_tip(tip_params) do
      {:ok, _tip} ->
        {:noreply,
         socket
         |> put_flash(:info, "Tip created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

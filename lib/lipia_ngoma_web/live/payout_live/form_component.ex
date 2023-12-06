defmodule LipiaNgomaWeb.PayoutLive.FormComponent do
  use LipiaNgomaWeb, :live_component

  alias LipiaNgoma.Payouts

  @impl true
  def update(%{payout: payout} = assigns, socket) do
    changeset = Payouts.change_payout(payout)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"payout" => payout_params}, socket) do
    changeset =
      socket.assigns.payout
      |> Payouts.change_payout(payout_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"payout" => payout_params}, socket) do
    save_payout(socket, socket.assigns.action, payout_params)
  end

  defp save_payout(socket, :edit, payout_params) do
    case Payouts.update_payout(socket.assigns.payout, payout_params) do
      {:ok, _payout} ->
        {:noreply,
         socket
         |> put_flash(:info, "Payout updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_payout(socket, :new, payout_params) do
    case Payouts.create_payout(payout_params) do
      {:ok, _payout} ->
        {:noreply,
         socket
         |> put_flash(:info, "Payout created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

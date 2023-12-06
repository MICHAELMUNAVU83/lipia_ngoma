defmodule LipiaNgomaWeb.PayoutLive.Index do
  use LipiaNgomaWeb, :live_view

  alias LipiaNgoma.Payouts
  alias LipiaNgoma.Users
  alias LipiaNgoma.Payouts.Payout

  @impl true
  def mount(_params, session, socket) do
    current_user = Users.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> assign(:current_user, current_user)
     |> assign(:payouts, list_payouts(current_user.id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Payout")
    |> assign(:payout, Payouts.get_payout!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Payout")
    |> assign(:payout, %Payout{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Payouts")
    |> assign(:payout, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    payout = Payouts.get_payout!(id)
    {:ok, _} = Payouts.delete_payout(payout)

    {:noreply, assign(socket, :payouts, list_payouts(socket.assigns.current_user.id))}
  end

  defp list_payouts(id) do
    Payouts.list_payouts_for_user(id)
  end
end

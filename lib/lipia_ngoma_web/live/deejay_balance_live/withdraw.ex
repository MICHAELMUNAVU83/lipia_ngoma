defmodule LipiaNgomaWeb.DeejayBalanceLive.Withdraw do
  use LipiaNgomaWeb, :deejay_live_view
  alias LipiaNgoma.Payouts
  alias LipiaNgoma.Users
  alias LipiaNgoma.Payouts.Payout
  alias LipiaNgoma.Chpter

  def mount(_params, session, socket) do
    current_user =
      Users.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> assign(:current_user, current_user)
     |> assign(:payout, %Payout{})
     |> assign(:changeset, Payouts.change_payout(%Payout{}))}
  end

  def handle_event("validate", %{"payout" => payout_params}, socket) do
    changeset =
      socket.assigns.payout
      |> Payouts.change_payout(payout_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"payout" => payout_params}, socket) do
    case(
      IO.inspect(
        Chpter.withdraw(
          payout_params["name"],
          "test@gmail.com",
          payout_params["phone_number"],
          String.to_integer(payout_params["amount"]),
          payout_params["payoutid"],
          "pk_4aff02227456f6b499820c2621ae181c9e35666d25865575fef47622265dcbb9"
        )
      )
    ) do
      {:ok, %HTTPoison.Response{status_code: 201, body: body}} ->
        case Payouts.create_payout(payout_params) do
          {:ok, payout} ->
            {:noreply,
             socket
             |> put_flash(:info, "Payout created successfully")
             |> push_redirect(
               to:
                 Routes.deejay_balance_success_path(
                   LipiaNgomaWeb.Endpoint,
                   :index,
                   payout.id
                 )
             )}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, changeset: changeset)}
        end

      {:ok, %HTTPoison.Response{status_code: 400, body: body}} ->
        {:noreply,
         socket
         |> put_flash(:error, "Payout Failed")}

      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "Payout Failed")}
    end
  end
end

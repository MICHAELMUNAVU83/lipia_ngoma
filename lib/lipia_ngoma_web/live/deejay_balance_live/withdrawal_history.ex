defmodule LipiaNgomaWeb.DeejayBalanceLive.WithdrawalHistory do
  use LipiaNgomaWeb, :deejay_live_view
  alias LipiaNgoma.Users

  alias LipiaNgoma.Payouts

  def mount(_params, session, socket) do
    current_user =
      Users.get_user_by_session_token(session["user_token"])

    payouts = Payouts.list_payouts_for_a_user(current_user.id)

    {:ok,
     socket
     |> assign(:payouts, payouts)
     |> assign(:current_user, current_user)}
  end
end

defmodule LipiaNgomaWeb.DeejayBalanceLive.Success do
  use LipiaNgomaWeb, :deejay_live_view
  alias LipiaNgoma.Users
  alias LipiaNgoma.Payouts

  def mount(params, session, socket) do
    payout = Payouts.get_payout!(params["payout_id"])

    current_user =
      Users.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> assign(:current_user, current_user)
     |> assign(:payout, payout)}
  end
end

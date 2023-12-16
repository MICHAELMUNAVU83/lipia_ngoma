defmodule LipiaNgomaWeb.DeejayBalanceLive.Index do
  use LipiaNgomaWeb, :deejay_live_view
  alias LipiaNgoma.Users

  def mount(_params, session, socket) do
    current_user =
      Users.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> assign(:current_user, current_user)}
  end
end

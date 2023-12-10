defmodule LipiaNgomaWeb.HomeLive.Index do
  use LipiaNgomaWeb, :live_view
  alias LipiaNgoma.Users

  def mount(_params, session, socket) do
    user_signed_in =
      if is_nil(session["user_token"]) do
        false
      else
        true
      end

    user =
      if user_signed_in do
        Users.get_user_by_session_token(session["user_token"])
      else
        nil
      end

    {:ok,
     socket
     |> assign(:user, user)}
  end
end

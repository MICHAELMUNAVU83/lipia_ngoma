defmodule LipiaNgomaWeb.MixLive.Index do
  use LipiaNgomaWeb, :live_view
  alias LipiaNgoma.Users

  def mount(_params, session, socket) do
    user = Users.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> assign(:user, user)}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, %{"username" => username}) do
    user = Users.get_user_by_username(username)

    socket
    |> assign(:page_title, "#{username} Mix Page")
    |> assign(:user, user)
  end
end

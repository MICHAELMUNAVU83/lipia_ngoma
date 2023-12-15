defmodule LipiaNgomaWeb.ClientMixtapeSongsLive.Index do
  use LipiaNgomaWeb, :live_view
  alias LipiaNgoma.Users

  def mount(_params, session, socket) do
    current_user =
      Users.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> assign(:current_user, current_user)}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, %{"username" => username}) do
    user = Users.get_user_by_username(username)

    socket
    |> assign(:page_title, "#{username} Home Page")
    |> assign(:user, user)
  end
end

defmodule LipiaNgomaWeb.ProfileLive.Index do
  use LipiaNgomaWeb, :deejay_live_view
  alias LipiaNgoma.Users
  alias LipiaNgoma.Mixtapes

  def mount(_params, session, socket) do
    current_user = Users.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> assign(:current_user, current_user)}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _) do
    socket
    |> assign(:page_title, "Profile")
  end
end

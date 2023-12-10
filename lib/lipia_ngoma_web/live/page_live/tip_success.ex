defmodule LipiaNgomaWeb.PageLive.TipSuccess do
  use LipiaNgomaWeb, :live_view
  alias LipiaNgoma.Users
  alias LipiaNgoma.Tips.Tip
  alias LipiaNgoma.Tips

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, %{"username" => username}) do
    user = Users.get_user_by_username(username)

    tips = Users.get_user_tips(username)

    socket
    |> assign(:user, user)
    |> assign(:page_title, "Success Tip for #{username} ")
  end
end

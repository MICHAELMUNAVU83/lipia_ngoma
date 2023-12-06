defmodule LipiaNgomaWeb.PageLive.Tips do
  use LipiaNgomaWeb, :live_view
  alias LipiaNgoma.Users
  alias LipiaNgoma.Tips.Tip
  alias LipiaNgoma.ClubOfTheDays

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
    |> assign(:tips, tips)
    |> assign(:page_title, "Add tips for #{username} Home Page")
  end

  defp apply_action(socket, :new, params) do
    user = Users.get_user_by_username(params["username"])

    tips = Users.get_user_tips(params["username"])

    socket
    |> assign(:page_title, "New Tip")
    |> assign(:tips, tips)
    |> assign(:user, user)
    |> assign(:tip, %Tip{})
  end
end

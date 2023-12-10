defmodule LipiaNgomaWeb.BoostLive.Success do
  use LipiaNgomaWeb, :live_view

  alias LipiaNgoma.Users
  alias LipiaNgoma.Boosts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, %{
         "username" => username,
         "boost_id" => boost_id
       }) do
    user = Users.get_user_by_username(username)
    boost = Boosts.get_boost!(boost_id)

    socket
    |> assign(:user, user)
    |> assign(:boost, boost)
    |> assign(:page_title, "Boost Success Page")
  end
end

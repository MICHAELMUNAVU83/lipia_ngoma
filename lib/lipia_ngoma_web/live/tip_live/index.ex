defmodule LipiaNgomaWeb.TipLive.Index do
  use LipiaNgomaWeb, :live_view

  alias LipiaNgoma.Tips
  alias LipiaNgoma.Users
  alias LipiaNgoma.Tips.Tip

  @impl true
  def mount(_params, session, socket) do
    user = Users.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> assign(:user, user)
     |> assign(:changeset, Tips.change_tip(%Tip{}))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, params) do
    tips =
      if params["q"] do
        Tips.search_tips(params["q"], socket.assigns.user.id)
      else
        list_tips(socket.assigns.user.id)
      end

    IO.inspect(tips)

    socket
    |> assign(:page_title, "Listing Tips")
    |> assign(:tips, tips)
    |> assign(:tip, nil)
  end

  def handle_event("search_tip", params, socket) do
    {:noreply,
     socket
     |> push_patch(to: "/tips/?q=#{params["tip"]["search"]}")}
  end

  @impl true

  defp list_tips(id) do
    Tips.list_tips_for_a_user(id)
  end
end

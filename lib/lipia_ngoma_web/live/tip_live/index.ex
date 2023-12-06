defmodule LipiaNgomaWeb.TipLive.Index do
  use LipiaNgomaWeb, :live_view

  alias LipiaNgoma.Tips
  alias LipiaNgoma.Users
  alias LipiaNgoma.Tips.Tip

  @impl true
  def mount(_params, session, socket) do
    current_user = Users.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> assign(:current_user, current_user)
     |> assign(:tips, list_tips(current_user.id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Tip")
    |> assign(:tip, Tips.get_tip!(id))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tips")
    |> assign(:tip, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    tip = Tips.get_tip!(id)
    {:ok, _} = Tips.delete_tip(tip)

    {:noreply, assign(socket, :tips, list_tips(socket.assigns.current_user.id))}
  end

  defp list_tips(id) do
    Tips.list_tips_for_a_user(id)
  end
end

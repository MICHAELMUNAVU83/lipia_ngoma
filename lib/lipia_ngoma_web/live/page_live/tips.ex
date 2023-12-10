defmodule LipiaNgomaWeb.PageLive.Tips do
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
    |> assign(:tip, %Tip{})
    |> assign(:changeset, Tips.change_tip(%Tip{}))
    |> assign(
      :return_to,
      Routes.page_tip_success_path(socket, :index, user.username)
    )
    |> assign(:tips, tips)
    |> assign(:page_title, "Add tips for #{username} Home Page")
  end

  def handle_event("validate", %{"tip" => tip_params}, socket) do
    changeset =
      socket.assigns.tip
      |> Tips.change_tip(tip_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"tip" => tip_params}, socket) do
    case Tips.create_tip(tip_params) do
      {:ok, _tip} ->
        {:noreply,
         socket
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

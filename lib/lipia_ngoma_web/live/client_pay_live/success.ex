defmodule LipiaNgomaWeb.ClientPayLive.Success do
  use LipiaNgomaWeb, :live_view

  alias LipiaNgoma.Users

  alias LipiaNgoma.Mixtapes

  @impl true
  def mount(_params, session, socket) do
    current_user = Users.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> assign(:current_user, current_user)}
  end

  @impl true

  def handle_params(params, _, socket) do
    user = Users.get_user_by_username(params["username"])

    mixtape = Mixtapes.get_mixtape!(params["mixtape_id"])

    {:noreply,
     socket
     |> assign(:username, params["username"])
     |> assign(:mixtape, mixtape)
     |> assign(:user, user)
     |> assign(:page_title, "Success Page")}
  end
end

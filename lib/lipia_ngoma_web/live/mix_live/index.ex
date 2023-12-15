defmodule LipiaNgomaWeb.MixLive.Index do
  use LipiaNgomaWeb, :live_view
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

  defp apply_action(socket, :index, %{"username" => username}) do
    user = Users.get_user_by_username(username)

    socket
    |> assign(:page_title, "#{username} Mix Page")
    |> assign(:user, user)
  end

  def handle_event("mixtape", _, socket) do
    mixtape = mixtape_maker(socket.assigns.current_user, socket.assigns.user)

    {:noreply,
     socket
     |> push_redirect(
       to:
         Routes.client_mixtape_songs_index_path(
           LipiaNgomaWeb.Endpoint,
           :index,
           socket.assigns.user.username,
           mixtape.id
         )
     )}
  end

  defp mixtape_maker(current_user, user) do
    case Mixtapes.get_mixtapes_for_a_user(current_user.id) do
      [] ->
        {:ok, mixtape} =
          Mixtapes.create_mixtape(%{client_id: current_user.id, dj_id: user.id, status: "pending"})

        mixtape

      _ ->
        case Mixtapes.get_mixtapes_for_a_user(current_user.id)
             |> Enum.filter(fn mixtape -> mixtape.status == "pending" end) do
          [] ->
            {:ok, mixtape} =
              Mixtapes.create_mixtape(%{
                client_id: current_user.id,
                dj_id: user.id,
                status: "pending"
              })

            mixtape

          _ ->
            mixtape =
              Mixtapes.get_mixtapes_for_a_user(current_user.id)
              |> Enum.filter(fn mixtape -> mixtape.status == "pending" end)
              |> List.last()

            mixtape
        end
    end
  end
end

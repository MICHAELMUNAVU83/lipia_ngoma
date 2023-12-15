defmodule LipiaNgomaWeb.ClientPayLive.Index do
  use LipiaNgomaWeb, :live_view

  alias LipiaNgoma.Users

  alias LipiaNgoma.Spotify

  alias LipiaNgoma.Mixtapes
  alias LipiaNgoma.Mixtapes.Mixtape
  alias LipiaNgoma.MixtapeSongs
  alias LipiaNgoma.MixtapeSongs.MixtapeSong
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
     |> assign(:changeset, Mixtapes.change_payment_mixtape(mixtape))
     |> assign(:songs, mixtape.mixtape_songs)
     |> assign(:user, user)
     |> assign(:page_title, "Payment Page")}
  end

  def handle_event("validate", %{"mixtape" => mixtape_params}, socket) do
    changeset =
      socket.assigns.mixtape
      |> Mixtapes.change_payment_mixtape(mixtape_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"mixtape" => mixtape_params}, socket) do
    new_mixtape_params = mixtape_params |> Map.put("status", "paid")

    case Mixtapes.update_payment_mixtape(socket.assigns.mixtape, new_mixtape_params) do
      {:ok, mixtape} ->
        {:noreply,
         socket
         |> push_redirect(
           to:
             Routes.client_pay_success_path(
               LipiaNgomaWeb.Endpoint,
               :index,
               socket.assigns.user.username,
               socket.assigns.mixtape.id
             )
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end

defmodule LipiaNgomaWeb.BoostLive.Index do
  use LipiaNgomaWeb, :live_view

  alias LipiaNgoma.Boosts
  alias LipiaNgoma.Boosts.Boost
  alias LipiaNgoma.Users
  alias LipiaNgoma.SongRequests.SongRequest
  alias LipiaNgoma.SongRequests
  alias LipiaNgoma.Chpter
  alias LipiaNgoma.TransactionAlgorithim

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
         "song_request_id" => song_request_id
       }) do
    user = Users.get_user_by_username(username)
    song_request = SongRequests.get_song_request!(song_request_id)

    socket
    |> assign(:user, user)
    |> assign(:song_request, song_request)
    |> assign(:boost, %Boost{})
    |> assign(:changeset, Boosts.change_boost(%Boost{}))
    |> assign(:page_title, "Add A boost for #{song_request.name} ")
  end

  def handle_event("validate", %{"boost" => boost_params}, socket) do
    changeset =
      socket.assigns.boost
      |> Boosts.change_boost(boost_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"boost" => boost_params}, socket) do
    transaction_reference =
      TransactionAlgorithm.code_reference_for_transaction(
        socket.assigns.user.id,
        boost_params["phone_number"]
      )

    case Chpter.initiate_payment(
           "pk_ed5555e00579aaa99fa4a9ed6b8078559256e3987730e737bdcf9334ead73a51",
           boost_params["phone_number"],
           boost_params["name"],
           "test@gmail.com",
           boost_params["price"],
           "Nairobi",
           "https://16ae-105-163-157-168.ngrok-free.app/api/transactions",
           transaction_reference
         ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        customer_record =
          Chpter.check_for_payment(
            transaction_reference,
            "https://16ae-105-163-157-168.ngrok-free.app/api/transactions"
          )

        new_boost_params =
          boost_params
          |> Map.put("song_request_id", socket.assigns.song_request.id)
          |> Map.put("boostid", transaction_reference)

        if customer_record["success"] == true do
          case Boosts.create_boost(new_boost_params) do
            {:ok, boost} ->
              {:noreply,
               socket
               |> push_redirect(
                 to:
                   Routes.boost_success_path(
                     LipiaNgomaWeb.Endpoint,
                     :index,
                     socket.assigns.user.username,
                     boost.id
                   )
               )}

            {:error, %Ecto.Changeset{} = changeset} ->
              {:noreply, assign(socket, changeset: changeset)}
          end
        else
          {:noreply,
           socket
           |> put_flash(:error, "Payment Failed , #{customer_record["message"]}")}
        end

      {:error, %HTTPoison.Error{reason: :timeout, id: nil}} ->
        customer_record =
          Chpter.check_for_payment(
            transaction_reference,
            "https://16ae-105-163-157-168.ngrok-free.app/api/transactions"
          )

        new_boost_params =
          boost_params
          |> Map.put("song_request_id", socket.assigns.song_request.id)
          |> Map.put("boostid", transaction_reference)

        if customer_record["success"] == true do
          case Boosts.create_boost(new_boost_params) do
            {:ok, boost} ->
              {:noreply,
               socket
               |> push_redirect(
                 to:
                   Routes.boost_success_path(
                     LipiaNgomaWeb.Endpoint,
                     :index,
                     socket.assigns.user.username,
                     boost.id
                   )
               )}

            {:error, %Ecto.Changeset{} = changeset} ->
              {:noreply, assign(socket, changeset: changeset)}
          end
        else
          {:noreply,
           socket
           |> put_flash(:error, "Payment Failed , #{customer_record["message"]}")}
        end

      {:ok, %HTTPoison.Response{status_code: 400, body: body}} ->
        {:noreply,
         socket
         |> put_flash(:error, "Payment Failed")}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:noreply,
         socket
         |> put_flash(:error, "Payment Failed , Timeout error")}
    end
  end
end

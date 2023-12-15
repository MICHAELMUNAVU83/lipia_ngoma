defmodule LipiaNgomaWeb.ClientPayLive.Index do
  use LipiaNgomaWeb, :live_view

  alias LipiaNgoma.Users

  alias LipiaNgoma.Spotify

  alias LipiaNgoma.Mixtapes
  alias LipiaNgoma.Mixtapes.Mixtape
  alias LipiaNgoma.MixtapeSongs
  alias LipiaNgoma.MixtapeSongs.MixtapeSong
  alias LipiaNgoma.TransactionAlgorithim
  alias LipiaNgoma.Chpter

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

    transaction_reference =
      TransactionAlgorithim.code_reference_for_transaction(
        Integer.to_string(socket.assigns.user.id),
        mixtape_params["phone_number"]
      )

    case Chpter.initiate_payment(
           "pk_4aff02227456f6b499820c2621ae181c9e35666d25865575fef47622265dcbb9",
           mixtape_params["phone_number"],
           mixtape_params["name"],
           "test@gmail.com",
           String.to_integer(mixtape_params["price"]),
           "Nairobi",
           transaction_reference
         ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        customer_record =
          Chpter.check_for_payment(transaction_reference)

        if customer_record["success"] == true do
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
        else
          {:noreply,
           socket
           |> put_flash(:error, "Payment Failed , #{customer_record["message"]}")}
        end

      {:error, %HTTPoison.Error{reason: :timeout, id: nil}} ->
        customer_record =
          Chpter.check_for_payment(transaction_reference)

        if customer_record["success"] == true do
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

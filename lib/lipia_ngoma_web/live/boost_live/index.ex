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

    position = SongRequests.get_song_position(song_request.id, user.id)

    socket
    |> assign(:user, user)
    |> assign(:song_request, song_request)
    |> assign(:position, position)
    |> assign(:boost, %Boost{})
    |> assign(:eventual_position, "")
    |> assign(:changeset, Boosts.change_boost(%Boost{}))
    |> assign(:page_title, "Add A boost for #{song_request.name} ")
  end

  def handle_event("validate", %{"boost" => boost_params}, socket) do
    IO.inspect(boost_params["price"])

    eventual_position =
      if boost_params["price"] != "" do
        SongRequests.get_eventual_song_position(
          String.to_integer(boost_params["price"]) + socket.assigns.song_request.price,
          socket.assigns.user.id
        )
      else
        ""
      end

    total_price =
      if boost_params["price"] != "" do
        String.to_integer(boost_params["price"]) + socket.assigns.song_request.price
      else
        ""
      end

    changeset =
      socket.assigns.boost
      |> Boosts.change_boost(boost_params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:changeset, changeset)
     |> assign(:price, boost_params["price"])
     |> assign(
       :total_price,
       total_price
     )
     |> assign(:eventual_position, eventual_position)}
  end

  def handle_event("save", %{"boost" => boost_params}, socket) do
    transaction_reference =
      TransactionAlgorithim.code_reference_for_transaction(
        Integer.to_string(socket.assigns.user.id),
        boost_params["phone_number"]
      )

    case Chpter.initiate_payment(
           "pk_4aff02227456f6b499820c2621ae181c9e35666d25865575fef47622265dcbb9",
           boost_params["phone_number"],
           boost_params["name"],
           "test@gmail.com",
           String.to_integer(boost_params["price"]),
           "Nairobi",
           transaction_reference
         ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        customer_record =
          Chpter.check_for_payment(transaction_reference)

        new_boost_params =
          boost_params
          |> Map.put("song_request_id", socket.assigns.song_request.id)
          |> Map.put("boostid", transaction_reference)

        if customer_record["success"] == true do
          case Boosts.create_boost(new_boost_params) do
            {:ok, boost} ->
              {:ok, _song_request} =
                SongRequests.update_song_request(socket.assigns.song_request, %{
                  price:
                    socket.assigns.song_request.price + String.to_integer(boost_params["price"])
                })

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
          Chpter.check_for_payment(transaction_reference)

        new_boost_params =
          boost_params
          |> Map.put("song_request_id", socket.assigns.song_request.id)
          |> Map.put("boostid", transaction_reference)

        if customer_record["success"] == true do
          case Boosts.create_boost(new_boost_params) do
            {:ok, boost} ->
              {:ok, _song_request} =
                SongRequests.update_song_request(socket.assigns.song_request, %{
                  price:
                    socket.assigns.song_request.price + String.to_integer(boost_params["price"])
                })

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

defmodule LipiaNgomaWeb.PageLive.SongRequests do
  use LipiaNgomaWeb, :live_view
  alias LipiaNgoma.Users
  alias LipiaNgoma.Spotify
  alias LipiaNgoma.Chpter
  alias LipiaNgoma.SongRequests.SongRequest
  alias LipiaNgoma.SongRequests
  alias LipiaNgoma.TransactionAlgorithim

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:user_selected, false)}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, %{"username" => username, "track_id" => track_id}) do
    user = Users.get_user_by_username(username)

    track = Spotify.get_track(track_id)

    name_of_track = track["name"]

    artists =
      track["artists"]
      |> Enum.map(fn artist -> artist["name"] end)
      |> Enum.join(", ")

    image =
      track["album"]["images"]
      |> List.first()
      |> Map.get("url")

    socket
    |> assign(:user, user)
    |> assign(:song_request, %SongRequest{})
    |> assign(:name_of_track, name_of_track)
    |> assign(:artists, artists)
    |> assign(:songrequestid, track["id"])
    |> assign(:position, "")
    |> assign(:image, image)
    |> assign(:changeset, SongRequests.change_song_request(%SongRequest{}))
    |> assign(:page_title, "Add Song Requests for #{username} Home Page")
  end

  def handle_event("validate", %{"song_request" => song_request_params}, socket) do
    position =
      if song_request_params["price"] != "" do
        SongRequests.get_eventual_song_position(
          String.to_integer(song_request_params["price"]),
          socket.assigns.user.id
        )
      else
        ""
      end

    changeset =
      socket.assigns.song_request
      |> SongRequests.change_song_request(song_request_params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:changeset, changeset)
     |> assign(:price, song_request_params["price"])
     |> assign(:position, position)}
  end

  def handle_event("save", %{"song_request" => song_request_params}, socket) do
    transaction_reference =
      TransactionAlgorithim.code_reference_for_transaction(
        Integer.to_string(socket.assigns.user.id),
        song_request_params["phone_number"]
      )

    case Chpter.initiate_payment(
           "pk_4aff02227456f6b499820c2621ae181c9e35666d25865575fef47622265dcbb9",
           song_request_params["phone_number"],
           song_request_params["name"],
           "test@gmail.com",
           String.to_integer(song_request_params["price"]),
           "Nairobi",
           transaction_reference
         ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        customer_record =
          Chpter.check_for_payment(transaction_reference)

        new_song_request_params =
          song_request_params
          |> Map.put("artists", socket.assigns.artists)
          |> Map.put("song_name", socket.assigns.name_of_track)
          |> Map.put("image", socket.assigns.image)
          |> Map.put("songrequestid", socket.assigns.songrequestid)

        if customer_record["success"] == true do
          case SongRequests.create_song_request(new_song_request_params) do
            {:ok, song_request} ->
              {:noreply,
               socket
               |> push_redirect(
                 to:
                   Routes.page_song_requests_success_path(
                     LipiaNgomaWeb.Endpoint,
                     :index,
                     socket.assigns.user.username,
                     song_request.id
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

        new_song_request_params =
          song_request_params
          |> Map.put("artists", socket.assigns.artists)
          |> Map.put("song_name", socket.assigns.name_of_track)
          |> Map.put("image", socket.assigns.image)
          |> Map.put("songrequestid", socket.assigns.songrequestid)

        if customer_record["success"] == true do
          case SongRequests.create_song_request(new_song_request_params) do
            {:ok, song_request} ->
              {:noreply,
               socket
               |> push_redirect(
                 to:
                   Routes.page_song_requests_success_path(
                     LipiaNgomaWeb.Endpoint,
                     :index,
                     socket.assigns.user.username,
                     song_request.id
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

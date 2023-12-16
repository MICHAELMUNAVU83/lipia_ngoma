defmodule LipiaNgomaWeb.DeejaySongRequestLive.Index do
  use LipiaNgomaWeb, :deejay_live_view
  alias LipiaNgoma.Users
  alias LipiaNgoma.SongRequests
  alias LipiaNgoma.Chpter

  def mount(_params, session, socket) do
    current_user =
      Users.get_user_by_session_token(session["user_token"])

    songs = SongRequests.list_song_requests_for_a_user(current_user.id)

    {:ok,
     socket
     |> assign(:current_user, current_user)
     |> assign(:songs, songs)}
  end

  def handle_event("accept", %{"id" => id}, socket) do
    song_request = SongRequests.get_song_request!(id)

    {:ok, _} = SongRequests.update_song_request(song_request, %{is_played: true})

    songs = SongRequests.list_song_requests_for_a_user(socket.assigns.current_user.id)

    {:noreply,
     socket
     |> assign(:songs, songs)
     |> put_flash(:info, "Song request accepted")}
  end

  def handle_event("reject", %{"id" => id}, socket) do
    song_request = SongRequests.get_song_request!(id)

    payback_amount =
      (0.8 * song_request.price)
      |> Float.round(0)

    case(
      Chpter.withdraw(
        song_request.name,
        "test@gmail.com",
        song_request.phone_number,
        payback_amount,
        "456",
        "pk_0b51e48bc6ac135ce3f65b1355248cae71ef085c0223bc0273535a4e174dce07"
      )
    ) do
      {:ok, %HTTPoison.Response{status_code: 201, body: body}} ->
        {:ok, _} = SongRequests.update_song_request(song_request, %{is_refunded: true})

        songs = SongRequests.list_song_requests_for_a_user(socket.assigns.current_user.id)


        # send sms here

        {:noreply,
         socket
         |> assign(:songs, songs)
         |> put_flash(:info, "Song request rejected and refunded")}

      {:ok, %HTTPoison.Response{status_code: 400, body: body}} ->
        {:noreply,
         socket
         |> put_flash(:error, "Payout Failed")}

      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "Payout Failed")}
    end

    # {:ok, _} = SongRequests.update_song_request(song_request, %{is_played: true})

    # songs = SongRequests.list_song_requests_for_a_user(socket.assigns.current_user.id)

    # {:noreply,
    #  socket
    #  |> assign(:songs, songs)
    #  |> put_flash(:info, "Song request accepted")}
  end
end

defmodule LipiaNgoma.SongRequestsTest do
  use LipiaNgoma.DataCase

  alias LipiaNgoma.SongRequests

  describe "song_requests" do
    alias LipiaNgoma.SongRequests.SongRequest

    import LipiaNgoma.SongRequestsFixtures

    @invalid_attrs %{name: nil, phone_number: nil, price: nil, is_played: nil, is_refunded: nil, songrequestid: nil}

    test "list_song_requests/0 returns all song_requests" do
      song_request = song_request_fixture()
      assert SongRequests.list_song_requests() == [song_request]
    end

    test "get_song_request!/1 returns the song_request with given id" do
      song_request = song_request_fixture()
      assert SongRequests.get_song_request!(song_request.id) == song_request
    end

    test "create_song_request/1 with valid data creates a song_request" do
      valid_attrs = %{name: "some name", phone_number: "some phone_number", price: "some price", is_played: true, is_refunded: true, songrequestid: "some songrequestid"}

      assert {:ok, %SongRequest{} = song_request} = SongRequests.create_song_request(valid_attrs)
      assert song_request.name == "some name"
      assert song_request.phone_number == "some phone_number"
      assert song_request.price == "some price"
      assert song_request.is_played == true
      assert song_request.is_refunded == true
      assert song_request.songrequestid == "some songrequestid"
    end

    test "create_song_request/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SongRequests.create_song_request(@invalid_attrs)
    end

    test "update_song_request/2 with valid data updates the song_request" do
      song_request = song_request_fixture()
      update_attrs = %{name: "some updated name", phone_number: "some updated phone_number", price: "some updated price", is_played: false, is_refunded: false, songrequestid: "some updated songrequestid"}

      assert {:ok, %SongRequest{} = song_request} = SongRequests.update_song_request(song_request, update_attrs)
      assert song_request.name == "some updated name"
      assert song_request.phone_number == "some updated phone_number"
      assert song_request.price == "some updated price"
      assert song_request.is_played == false
      assert song_request.is_refunded == false
      assert song_request.songrequestid == "some updated songrequestid"
    end

    test "update_song_request/2 with invalid data returns error changeset" do
      song_request = song_request_fixture()
      assert {:error, %Ecto.Changeset{}} = SongRequests.update_song_request(song_request, @invalid_attrs)
      assert song_request == SongRequests.get_song_request!(song_request.id)
    end

    test "delete_song_request/1 deletes the song_request" do
      song_request = song_request_fixture()
      assert {:ok, %SongRequest{}} = SongRequests.delete_song_request(song_request)
      assert_raise Ecto.NoResultsError, fn -> SongRequests.get_song_request!(song_request.id) end
    end

    test "change_song_request/1 returns a song_request changeset" do
      song_request = song_request_fixture()
      assert %Ecto.Changeset{} = SongRequests.change_song_request(song_request)
    end
  end
end

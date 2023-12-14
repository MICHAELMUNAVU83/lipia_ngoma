defmodule LipiaNgoma.SpotifyPlaylistsTest do
  use LipiaNgoma.DataCase

  alias LipiaNgoma.SpotifyPlaylists

  describe "spotify_playlists" do
    alias LipiaNgoma.SpotifyPlaylists.SpotifyPlaylist

    import LipiaNgoma.SpotifyPlaylistsFixtures

    @invalid_attrs %{name: nil, status: nil, phone_number: nil, price: nil}

    test "list_spotify_playlists/0 returns all spotify_playlists" do
      spotify_playlist = spotify_playlist_fixture()
      assert SpotifyPlaylists.list_spotify_playlists() == [spotify_playlist]
    end

    test "get_spotify_playlist!/1 returns the spotify_playlist with given id" do
      spotify_playlist = spotify_playlist_fixture()
      assert SpotifyPlaylists.get_spotify_playlist!(spotify_playlist.id) == spotify_playlist
    end

    test "create_spotify_playlist/1 with valid data creates a spotify_playlist" do
      valid_attrs = %{name: "some name", status: "some status", phone_number: "some phone_number", price: 42}

      assert {:ok, %SpotifyPlaylist{} = spotify_playlist} = SpotifyPlaylists.create_spotify_playlist(valid_attrs)
      assert spotify_playlist.name == "some name"
      assert spotify_playlist.status == "some status"
      assert spotify_playlist.phone_number == "some phone_number"
      assert spotify_playlist.price == 42
    end

    test "create_spotify_playlist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SpotifyPlaylists.create_spotify_playlist(@invalid_attrs)
    end

    test "update_spotify_playlist/2 with valid data updates the spotify_playlist" do
      spotify_playlist = spotify_playlist_fixture()
      update_attrs = %{name: "some updated name", status: "some updated status", phone_number: "some updated phone_number", price: 43}

      assert {:ok, %SpotifyPlaylist{} = spotify_playlist} = SpotifyPlaylists.update_spotify_playlist(spotify_playlist, update_attrs)
      assert spotify_playlist.name == "some updated name"
      assert spotify_playlist.status == "some updated status"
      assert spotify_playlist.phone_number == "some updated phone_number"
      assert spotify_playlist.price == 43
    end

    test "update_spotify_playlist/2 with invalid data returns error changeset" do
      spotify_playlist = spotify_playlist_fixture()
      assert {:error, %Ecto.Changeset{}} = SpotifyPlaylists.update_spotify_playlist(spotify_playlist, @invalid_attrs)
      assert spotify_playlist == SpotifyPlaylists.get_spotify_playlist!(spotify_playlist.id)
    end

    test "delete_spotify_playlist/1 deletes the spotify_playlist" do
      spotify_playlist = spotify_playlist_fixture()
      assert {:ok, %SpotifyPlaylist{}} = SpotifyPlaylists.delete_spotify_playlist(spotify_playlist)
      assert_raise Ecto.NoResultsError, fn -> SpotifyPlaylists.get_spotify_playlist!(spotify_playlist.id) end
    end

    test "change_spotify_playlist/1 returns a spotify_playlist changeset" do
      spotify_playlist = spotify_playlist_fixture()
      assert %Ecto.Changeset{} = SpotifyPlaylists.change_spotify_playlist(spotify_playlist)
    end
  end
end

defmodule LipiaNgoma.MixtapeSongsTest do
  use LipiaNgoma.DataCase

  alias LipiaNgoma.MixtapeSongs

  describe "mixtape_songs" do
    alias LipiaNgoma.MixtapeSongs.MixtapeSong

    import LipiaNgoma.MixtapeSongsFixtures

    @invalid_attrs %{image: nil, song_name: nil, artists: nil}

    test "list_mixtape_songs/0 returns all mixtape_songs" do
      mixtape_song = mixtape_song_fixture()
      assert MixtapeSongs.list_mixtape_songs() == [mixtape_song]
    end

    test "get_mixtape_song!/1 returns the mixtape_song with given id" do
      mixtape_song = mixtape_song_fixture()
      assert MixtapeSongs.get_mixtape_song!(mixtape_song.id) == mixtape_song
    end

    test "create_mixtape_song/1 with valid data creates a mixtape_song" do
      valid_attrs = %{image: "some image", song_name: "some song_name", artists: "some artists"}

      assert {:ok, %MixtapeSong{} = mixtape_song} = MixtapeSongs.create_mixtape_song(valid_attrs)
      assert mixtape_song.image == "some image"
      assert mixtape_song.song_name == "some song_name"
      assert mixtape_song.artists == "some artists"
    end

    test "create_mixtape_song/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = MixtapeSongs.create_mixtape_song(@invalid_attrs)
    end

    test "update_mixtape_song/2 with valid data updates the mixtape_song" do
      mixtape_song = mixtape_song_fixture()
      update_attrs = %{image: "some updated image", song_name: "some updated song_name", artists: "some updated artists"}

      assert {:ok, %MixtapeSong{} = mixtape_song} = MixtapeSongs.update_mixtape_song(mixtape_song, update_attrs)
      assert mixtape_song.image == "some updated image"
      assert mixtape_song.song_name == "some updated song_name"
      assert mixtape_song.artists == "some updated artists"
    end

    test "update_mixtape_song/2 with invalid data returns error changeset" do
      mixtape_song = mixtape_song_fixture()
      assert {:error, %Ecto.Changeset{}} = MixtapeSongs.update_mixtape_song(mixtape_song, @invalid_attrs)
      assert mixtape_song == MixtapeSongs.get_mixtape_song!(mixtape_song.id)
    end

    test "delete_mixtape_song/1 deletes the mixtape_song" do
      mixtape_song = mixtape_song_fixture()
      assert {:ok, %MixtapeSong{}} = MixtapeSongs.delete_mixtape_song(mixtape_song)
      assert_raise Ecto.NoResultsError, fn -> MixtapeSongs.get_mixtape_song!(mixtape_song.id) end
    end

    test "change_mixtape_song/1 returns a mixtape_song changeset" do
      mixtape_song = mixtape_song_fixture()
      assert %Ecto.Changeset{} = MixtapeSongs.change_mixtape_song(mixtape_song)
    end
  end
end

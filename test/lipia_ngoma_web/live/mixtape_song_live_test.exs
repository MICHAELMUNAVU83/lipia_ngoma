defmodule LipiaNgomaWeb.MixtapeSongLiveTest do
  use LipiaNgomaWeb.ConnCase

  import Phoenix.LiveViewTest
  import LipiaNgoma.MixtapeSongsFixtures

  @create_attrs %{image: "some image", song_name: "some song_name", artists: "some artists"}
  @update_attrs %{image: "some updated image", song_name: "some updated song_name", artists: "some updated artists"}
  @invalid_attrs %{image: nil, song_name: nil, artists: nil}

  defp create_mixtape_song(_) do
    mixtape_song = mixtape_song_fixture()
    %{mixtape_song: mixtape_song}
  end

  describe "Index" do
    setup [:create_mixtape_song]

    test "lists all mixtape_songs", %{conn: conn, mixtape_song: mixtape_song} do
      {:ok, _index_live, html} = live(conn, Routes.mixtape_song_index_path(conn, :index))

      assert html =~ "Listing Mixtape songs"
      assert html =~ mixtape_song.image
    end

    test "saves new mixtape_song", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.mixtape_song_index_path(conn, :index))

      assert index_live |> element("a", "New Mixtape song") |> render_click() =~
               "New Mixtape song"

      assert_patch(index_live, Routes.mixtape_song_index_path(conn, :new))

      assert index_live
             |> form("#mixtape_song-form", mixtape_song: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#mixtape_song-form", mixtape_song: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.mixtape_song_index_path(conn, :index))

      assert html =~ "Mixtape song created successfully"
      assert html =~ "some image"
    end

    test "updates mixtape_song in listing", %{conn: conn, mixtape_song: mixtape_song} do
      {:ok, index_live, _html} = live(conn, Routes.mixtape_song_index_path(conn, :index))

      assert index_live |> element("#mixtape_song-#{mixtape_song.id} a", "Edit") |> render_click() =~
               "Edit Mixtape song"

      assert_patch(index_live, Routes.mixtape_song_index_path(conn, :edit, mixtape_song))

      assert index_live
             |> form("#mixtape_song-form", mixtape_song: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#mixtape_song-form", mixtape_song: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.mixtape_song_index_path(conn, :index))

      assert html =~ "Mixtape song updated successfully"
      assert html =~ "some updated image"
    end

    test "deletes mixtape_song in listing", %{conn: conn, mixtape_song: mixtape_song} do
      {:ok, index_live, _html} = live(conn, Routes.mixtape_song_index_path(conn, :index))

      assert index_live |> element("#mixtape_song-#{mixtape_song.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#mixtape_song-#{mixtape_song.id}")
    end
  end

  describe "Show" do
    setup [:create_mixtape_song]

    test "displays mixtape_song", %{conn: conn, mixtape_song: mixtape_song} do
      {:ok, _show_live, html} = live(conn, Routes.mixtape_song_show_path(conn, :show, mixtape_song))

      assert html =~ "Show Mixtape song"
      assert html =~ mixtape_song.image
    end

    test "updates mixtape_song within modal", %{conn: conn, mixtape_song: mixtape_song} do
      {:ok, show_live, _html} = live(conn, Routes.mixtape_song_show_path(conn, :show, mixtape_song))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Mixtape song"

      assert_patch(show_live, Routes.mixtape_song_show_path(conn, :edit, mixtape_song))

      assert show_live
             |> form("#mixtape_song-form", mixtape_song: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#mixtape_song-form", mixtape_song: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.mixtape_song_show_path(conn, :show, mixtape_song))

      assert html =~ "Mixtape song updated successfully"
      assert html =~ "some updated image"
    end
  end
end

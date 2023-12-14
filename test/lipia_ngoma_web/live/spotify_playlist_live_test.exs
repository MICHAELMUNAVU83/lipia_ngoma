defmodule LipiaNgomaWeb.SpotifyPlaylistLiveTest do
  use LipiaNgomaWeb.ConnCase

  import Phoenix.LiveViewTest
  import LipiaNgoma.SpotifyPlaylistsFixtures

  @create_attrs %{name: "some name", status: "some status", phone_number: "some phone_number", price: 42}
  @update_attrs %{name: "some updated name", status: "some updated status", phone_number: "some updated phone_number", price: 43}
  @invalid_attrs %{name: nil, status: nil, phone_number: nil, price: nil}

  defp create_spotify_playlist(_) do
    spotify_playlist = spotify_playlist_fixture()
    %{spotify_playlist: spotify_playlist}
  end

  describe "Index" do
    setup [:create_spotify_playlist]

    test "lists all spotify_playlists", %{conn: conn, spotify_playlist: spotify_playlist} do
      {:ok, _index_live, html} = live(conn, Routes.spotify_playlist_index_path(conn, :index))

      assert html =~ "Listing Spotify playlists"
      assert html =~ spotify_playlist.name
    end

    test "saves new spotify_playlist", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.spotify_playlist_index_path(conn, :index))

      assert index_live |> element("a", "New Spotify playlist") |> render_click() =~
               "New Spotify playlist"

      assert_patch(index_live, Routes.spotify_playlist_index_path(conn, :new))

      assert index_live
             |> form("#spotify_playlist-form", spotify_playlist: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#spotify_playlist-form", spotify_playlist: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.spotify_playlist_index_path(conn, :index))

      assert html =~ "Spotify playlist created successfully"
      assert html =~ "some name"
    end

    test "updates spotify_playlist in listing", %{conn: conn, spotify_playlist: spotify_playlist} do
      {:ok, index_live, _html} = live(conn, Routes.spotify_playlist_index_path(conn, :index))

      assert index_live |> element("#spotify_playlist-#{spotify_playlist.id} a", "Edit") |> render_click() =~
               "Edit Spotify playlist"

      assert_patch(index_live, Routes.spotify_playlist_index_path(conn, :edit, spotify_playlist))

      assert index_live
             |> form("#spotify_playlist-form", spotify_playlist: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#spotify_playlist-form", spotify_playlist: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.spotify_playlist_index_path(conn, :index))

      assert html =~ "Spotify playlist updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes spotify_playlist in listing", %{conn: conn, spotify_playlist: spotify_playlist} do
      {:ok, index_live, _html} = live(conn, Routes.spotify_playlist_index_path(conn, :index))

      assert index_live |> element("#spotify_playlist-#{spotify_playlist.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#spotify_playlist-#{spotify_playlist.id}")
    end
  end

  describe "Show" do
    setup [:create_spotify_playlist]

    test "displays spotify_playlist", %{conn: conn, spotify_playlist: spotify_playlist} do
      {:ok, _show_live, html} = live(conn, Routes.spotify_playlist_show_path(conn, :show, spotify_playlist))

      assert html =~ "Show Spotify playlist"
      assert html =~ spotify_playlist.name
    end

    test "updates spotify_playlist within modal", %{conn: conn, spotify_playlist: spotify_playlist} do
      {:ok, show_live, _html} = live(conn, Routes.spotify_playlist_show_path(conn, :show, spotify_playlist))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Spotify playlist"

      assert_patch(show_live, Routes.spotify_playlist_show_path(conn, :edit, spotify_playlist))

      assert show_live
             |> form("#spotify_playlist-form", spotify_playlist: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#spotify_playlist-form", spotify_playlist: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.spotify_playlist_show_path(conn, :show, spotify_playlist))

      assert html =~ "Spotify playlist updated successfully"
      assert html =~ "some updated name"
    end
  end
end

defmodule LipiaNgomaWeb.SongRequestLiveTest do
  use LipiaNgomaWeb.ConnCase

  import Phoenix.LiveViewTest
  import LipiaNgoma.SongRequestsFixtures

  @create_attrs %{name: "some name", phone_number: "some phone_number", price: "some price", is_played: true, is_refunded: true, songrequestid: "some songrequestid"}
  @update_attrs %{name: "some updated name", phone_number: "some updated phone_number", price: "some updated price", is_played: false, is_refunded: false, songrequestid: "some updated songrequestid"}
  @invalid_attrs %{name: nil, phone_number: nil, price: nil, is_played: false, is_refunded: false, songrequestid: nil}

  defp create_song_request(_) do
    song_request = song_request_fixture()
    %{song_request: song_request}
  end

  describe "Index" do
    setup [:create_song_request]

    test "lists all song_requests", %{conn: conn, song_request: song_request} do
      {:ok, _index_live, html} = live(conn, Routes.song_request_index_path(conn, :index))

      assert html =~ "Listing Song requests"
      assert html =~ song_request.name
    end

    test "saves new song_request", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.song_request_index_path(conn, :index))

      assert index_live |> element("a", "New Song request") |> render_click() =~
               "New Song request"

      assert_patch(index_live, Routes.song_request_index_path(conn, :new))

      assert index_live
             |> form("#song_request-form", song_request: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#song_request-form", song_request: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.song_request_index_path(conn, :index))

      assert html =~ "Song request created successfully"
      assert html =~ "some name"
    end

    test "updates song_request in listing", %{conn: conn, song_request: song_request} do
      {:ok, index_live, _html} = live(conn, Routes.song_request_index_path(conn, :index))

      assert index_live |> element("#song_request-#{song_request.id} a", "Edit") |> render_click() =~
               "Edit Song request"

      assert_patch(index_live, Routes.song_request_index_path(conn, :edit, song_request))

      assert index_live
             |> form("#song_request-form", song_request: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#song_request-form", song_request: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.song_request_index_path(conn, :index))

      assert html =~ "Song request updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes song_request in listing", %{conn: conn, song_request: song_request} do
      {:ok, index_live, _html} = live(conn, Routes.song_request_index_path(conn, :index))

      assert index_live |> element("#song_request-#{song_request.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#song_request-#{song_request.id}")
    end
  end

  describe "Show" do
    setup [:create_song_request]

    test "displays song_request", %{conn: conn, song_request: song_request} do
      {:ok, _show_live, html} = live(conn, Routes.song_request_show_path(conn, :show, song_request))

      assert html =~ "Show Song request"
      assert html =~ song_request.name
    end

    test "updates song_request within modal", %{conn: conn, song_request: song_request} do
      {:ok, show_live, _html} = live(conn, Routes.song_request_show_path(conn, :show, song_request))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Song request"

      assert_patch(show_live, Routes.song_request_show_path(conn, :edit, song_request))

      assert show_live
             |> form("#song_request-form", song_request: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#song_request-form", song_request: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.song_request_show_path(conn, :show, song_request))

      assert html =~ "Song request updated successfully"
      assert html =~ "some updated name"
    end
  end
end

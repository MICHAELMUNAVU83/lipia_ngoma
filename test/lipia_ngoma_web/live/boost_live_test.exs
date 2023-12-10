defmodule LipiaNgomaWeb.BoostLiveTest do
  use LipiaNgomaWeb.ConnCase

  import Phoenix.LiveViewTest
  import LipiaNgoma.BoostsFixtures

  @create_attrs %{name: "some name", phone_number: "some phone_number", price: 42}
  @update_attrs %{name: "some updated name", phone_number: "some updated phone_number", price: 43}
  @invalid_attrs %{name: nil, phone_number: nil, price: nil}

  defp create_boost(_) do
    boost = boost_fixture()
    %{boost: boost}
  end

  describe "Index" do
    setup [:create_boost]

    test "lists all boosts", %{conn: conn, boost: boost} do
      {:ok, _index_live, html} = live(conn, Routes.boost_index_path(conn, :index))

      assert html =~ "Listing Boosts"
      assert html =~ boost.name
    end

    test "saves new boost", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.boost_index_path(conn, :index))

      assert index_live |> element("a", "New Boost") |> render_click() =~
               "New Boost"

      assert_patch(index_live, Routes.boost_index_path(conn, :new))

      assert index_live
             |> form("#boost-form", boost: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#boost-form", boost: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.boost_index_path(conn, :index))

      assert html =~ "Boost created successfully"
      assert html =~ "some name"
    end

    test "updates boost in listing", %{conn: conn, boost: boost} do
      {:ok, index_live, _html} = live(conn, Routes.boost_index_path(conn, :index))

      assert index_live |> element("#boost-#{boost.id} a", "Edit") |> render_click() =~
               "Edit Boost"

      assert_patch(index_live, Routes.boost_index_path(conn, :edit, boost))

      assert index_live
             |> form("#boost-form", boost: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#boost-form", boost: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.boost_index_path(conn, :index))

      assert html =~ "Boost updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes boost in listing", %{conn: conn, boost: boost} do
      {:ok, index_live, _html} = live(conn, Routes.boost_index_path(conn, :index))

      assert index_live |> element("#boost-#{boost.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#boost-#{boost.id}")
    end
  end

  describe "Show" do
    setup [:create_boost]

    test "displays boost", %{conn: conn, boost: boost} do
      {:ok, _show_live, html} = live(conn, Routes.boost_show_path(conn, :show, boost))

      assert html =~ "Show Boost"
      assert html =~ boost.name
    end

    test "updates boost within modal", %{conn: conn, boost: boost} do
      {:ok, show_live, _html} = live(conn, Routes.boost_show_path(conn, :show, boost))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Boost"

      assert_patch(show_live, Routes.boost_show_path(conn, :edit, boost))

      assert show_live
             |> form("#boost-form", boost: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#boost-form", boost: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.boost_show_path(conn, :show, boost))

      assert html =~ "Boost updated successfully"
      assert html =~ "some updated name"
    end
  end
end

defmodule LipiaNgomaWeb.TipLiveTest do
  use LipiaNgomaWeb.ConnCase

  import Phoenix.LiveViewTest
  import LipiaNgoma.TipsFixtures

  @create_attrs %{name: "some name", phone_number: "some phone_number", price: 42, tipid: "some tipid"}
  @update_attrs %{name: "some updated name", phone_number: "some updated phone_number", price: 43, tipid: "some updated tipid"}
  @invalid_attrs %{name: nil, phone_number: nil, price: nil, tipid: nil}

  defp create_tip(_) do
    tip = tip_fixture()
    %{tip: tip}
  end

  describe "Index" do
    setup [:create_tip]

    test "lists all tips", %{conn: conn, tip: tip} do
      {:ok, _index_live, html} = live(conn, Routes.tip_index_path(conn, :index))

      assert html =~ "Listing Tips"
      assert html =~ tip.name
    end

    test "saves new tip", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.tip_index_path(conn, :index))

      assert index_live |> element("a", "New Tip") |> render_click() =~
               "New Tip"

      assert_patch(index_live, Routes.tip_index_path(conn, :new))

      assert index_live
             |> form("#tip-form", tip: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#tip-form", tip: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.tip_index_path(conn, :index))

      assert html =~ "Tip created successfully"
      assert html =~ "some name"
    end

    test "updates tip in listing", %{conn: conn, tip: tip} do
      {:ok, index_live, _html} = live(conn, Routes.tip_index_path(conn, :index))

      assert index_live |> element("#tip-#{tip.id} a", "Edit") |> render_click() =~
               "Edit Tip"

      assert_patch(index_live, Routes.tip_index_path(conn, :edit, tip))

      assert index_live
             |> form("#tip-form", tip: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#tip-form", tip: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.tip_index_path(conn, :index))

      assert html =~ "Tip updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes tip in listing", %{conn: conn, tip: tip} do
      {:ok, index_live, _html} = live(conn, Routes.tip_index_path(conn, :index))

      assert index_live |> element("#tip-#{tip.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#tip-#{tip.id}")
    end
  end

  describe "Show" do
    setup [:create_tip]

    test "displays tip", %{conn: conn, tip: tip} do
      {:ok, _show_live, html} = live(conn, Routes.tip_show_path(conn, :show, tip))

      assert html =~ "Show Tip"
      assert html =~ tip.name
    end

    test "updates tip within modal", %{conn: conn, tip: tip} do
      {:ok, show_live, _html} = live(conn, Routes.tip_show_path(conn, :show, tip))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Tip"

      assert_patch(show_live, Routes.tip_show_path(conn, :edit, tip))

      assert show_live
             |> form("#tip-form", tip: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#tip-form", tip: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.tip_show_path(conn, :show, tip))

      assert html =~ "Tip updated successfully"
      assert html =~ "some updated name"
    end
  end
end

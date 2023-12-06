defmodule LipiaNgomaWeb.PayoutLiveTest do
  use LipiaNgomaWeb.ConnCase

  import Phoenix.LiveViewTest
  import LipiaNgoma.PayoutsFixtures

  @create_attrs %{name: "some name", amount: 42, phone_number: "some phone_number", payoutid: "some payoutid"}
  @update_attrs %{name: "some updated name", amount: 43, phone_number: "some updated phone_number", payoutid: "some updated payoutid"}
  @invalid_attrs %{name: nil, amount: nil, phone_number: nil, payoutid: nil}

  defp create_payout(_) do
    payout = payout_fixture()
    %{payout: payout}
  end

  describe "Index" do
    setup [:create_payout]

    test "lists all payouts", %{conn: conn, payout: payout} do
      {:ok, _index_live, html} = live(conn, Routes.payout_index_path(conn, :index))

      assert html =~ "Listing Payouts"
      assert html =~ payout.name
    end

    test "saves new payout", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.payout_index_path(conn, :index))

      assert index_live |> element("a", "New Payout") |> render_click() =~
               "New Payout"

      assert_patch(index_live, Routes.payout_index_path(conn, :new))

      assert index_live
             |> form("#payout-form", payout: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#payout-form", payout: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.payout_index_path(conn, :index))

      assert html =~ "Payout created successfully"
      assert html =~ "some name"
    end

    test "updates payout in listing", %{conn: conn, payout: payout} do
      {:ok, index_live, _html} = live(conn, Routes.payout_index_path(conn, :index))

      assert index_live |> element("#payout-#{payout.id} a", "Edit") |> render_click() =~
               "Edit Payout"

      assert_patch(index_live, Routes.payout_index_path(conn, :edit, payout))

      assert index_live
             |> form("#payout-form", payout: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#payout-form", payout: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.payout_index_path(conn, :index))

      assert html =~ "Payout updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes payout in listing", %{conn: conn, payout: payout} do
      {:ok, index_live, _html} = live(conn, Routes.payout_index_path(conn, :index))

      assert index_live |> element("#payout-#{payout.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#payout-#{payout.id}")
    end
  end

  describe "Show" do
    setup [:create_payout]

    test "displays payout", %{conn: conn, payout: payout} do
      {:ok, _show_live, html} = live(conn, Routes.payout_show_path(conn, :show, payout))

      assert html =~ "Show Payout"
      assert html =~ payout.name
    end

    test "updates payout within modal", %{conn: conn, payout: payout} do
      {:ok, show_live, _html} = live(conn, Routes.payout_show_path(conn, :show, payout))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Payout"

      assert_patch(show_live, Routes.payout_show_path(conn, :edit, payout))

      assert show_live
             |> form("#payout-form", payout: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#payout-form", payout: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.payout_show_path(conn, :show, payout))

      assert html =~ "Payout updated successfully"
      assert html =~ "some updated name"
    end
  end
end

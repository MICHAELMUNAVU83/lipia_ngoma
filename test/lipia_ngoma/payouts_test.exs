defmodule LipiaNgoma.PayoutsTest do
  use LipiaNgoma.DataCase

  alias LipiaNgoma.Payouts

  describe "payouts" do
    alias LipiaNgoma.Payouts.Payout

    import LipiaNgoma.PayoutsFixtures

    @invalid_attrs %{name: nil, amount: nil, phone_number: nil, payoutid: nil}

    test "list_payouts/0 returns all payouts" do
      payout = payout_fixture()
      assert Payouts.list_payouts() == [payout]
    end

    test "get_payout!/1 returns the payout with given id" do
      payout = payout_fixture()
      assert Payouts.get_payout!(payout.id) == payout
    end

    test "create_payout/1 with valid data creates a payout" do
      valid_attrs = %{name: "some name", amount: 42, phone_number: "some phone_number", payoutid: "some payoutid"}

      assert {:ok, %Payout{} = payout} = Payouts.create_payout(valid_attrs)
      assert payout.name == "some name"
      assert payout.amount == 42
      assert payout.phone_number == "some phone_number"
      assert payout.payoutid == "some payoutid"
    end

    test "create_payout/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Payouts.create_payout(@invalid_attrs)
    end

    test "update_payout/2 with valid data updates the payout" do
      payout = payout_fixture()
      update_attrs = %{name: "some updated name", amount: 43, phone_number: "some updated phone_number", payoutid: "some updated payoutid"}

      assert {:ok, %Payout{} = payout} = Payouts.update_payout(payout, update_attrs)
      assert payout.name == "some updated name"
      assert payout.amount == 43
      assert payout.phone_number == "some updated phone_number"
      assert payout.payoutid == "some updated payoutid"
    end

    test "update_payout/2 with invalid data returns error changeset" do
      payout = payout_fixture()
      assert {:error, %Ecto.Changeset{}} = Payouts.update_payout(payout, @invalid_attrs)
      assert payout == Payouts.get_payout!(payout.id)
    end

    test "delete_payout/1 deletes the payout" do
      payout = payout_fixture()
      assert {:ok, %Payout{}} = Payouts.delete_payout(payout)
      assert_raise Ecto.NoResultsError, fn -> Payouts.get_payout!(payout.id) end
    end

    test "change_payout/1 returns a payout changeset" do
      payout = payout_fixture()
      assert %Ecto.Changeset{} = Payouts.change_payout(payout)
    end
  end
end

defmodule LipiaNgoma.TipsTest do
  use LipiaNgoma.DataCase

  alias LipiaNgoma.Tips

  describe "tips" do
    alias LipiaNgoma.Tips.Tip

    import LipiaNgoma.TipsFixtures

    @invalid_attrs %{name: nil, phone_number: nil, price: nil, tipid: nil}

    test "list_tips/0 returns all tips" do
      tip = tip_fixture()
      assert Tips.list_tips() == [tip]
    end

    test "get_tip!/1 returns the tip with given id" do
      tip = tip_fixture()
      assert Tips.get_tip!(tip.id) == tip
    end

    test "create_tip/1 with valid data creates a tip" do
      valid_attrs = %{name: "some name", phone_number: "some phone_number", price: 42, tipid: "some tipid"}

      assert {:ok, %Tip{} = tip} = Tips.create_tip(valid_attrs)
      assert tip.name == "some name"
      assert tip.phone_number == "some phone_number"
      assert tip.price == 42
      assert tip.tipid == "some tipid"
    end

    test "create_tip/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tips.create_tip(@invalid_attrs)
    end

    test "update_tip/2 with valid data updates the tip" do
      tip = tip_fixture()
      update_attrs = %{name: "some updated name", phone_number: "some updated phone_number", price: 43, tipid: "some updated tipid"}

      assert {:ok, %Tip{} = tip} = Tips.update_tip(tip, update_attrs)
      assert tip.name == "some updated name"
      assert tip.phone_number == "some updated phone_number"
      assert tip.price == 43
      assert tip.tipid == "some updated tipid"
    end

    test "update_tip/2 with invalid data returns error changeset" do
      tip = tip_fixture()
      assert {:error, %Ecto.Changeset{}} = Tips.update_tip(tip, @invalid_attrs)
      assert tip == Tips.get_tip!(tip.id)
    end

    test "delete_tip/1 deletes the tip" do
      tip = tip_fixture()
      assert {:ok, %Tip{}} = Tips.delete_tip(tip)
      assert_raise Ecto.NoResultsError, fn -> Tips.get_tip!(tip.id) end
    end

    test "change_tip/1 returns a tip changeset" do
      tip = tip_fixture()
      assert %Ecto.Changeset{} = Tips.change_tip(tip)
    end
  end
end

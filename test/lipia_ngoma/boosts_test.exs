defmodule LipiaNgoma.BoostsTest do
  use LipiaNgoma.DataCase

  alias LipiaNgoma.Boosts

  describe "boosts" do
    alias LipiaNgoma.Boosts.Boost

    import LipiaNgoma.BoostsFixtures

    @invalid_attrs %{name: nil, phone_number: nil, price: nil}

    test "list_boosts/0 returns all boosts" do
      boost = boost_fixture()
      assert Boosts.list_boosts() == [boost]
    end

    test "get_boost!/1 returns the boost with given id" do
      boost = boost_fixture()
      assert Boosts.get_boost!(boost.id) == boost
    end

    test "create_boost/1 with valid data creates a boost" do
      valid_attrs = %{name: "some name", phone_number: "some phone_number", price: 42}

      assert {:ok, %Boost{} = boost} = Boosts.create_boost(valid_attrs)
      assert boost.name == "some name"
      assert boost.phone_number == "some phone_number"
      assert boost.price == 42
    end

    test "create_boost/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Boosts.create_boost(@invalid_attrs)
    end

    test "update_boost/2 with valid data updates the boost" do
      boost = boost_fixture()
      update_attrs = %{name: "some updated name", phone_number: "some updated phone_number", price: 43}

      assert {:ok, %Boost{} = boost} = Boosts.update_boost(boost, update_attrs)
      assert boost.name == "some updated name"
      assert boost.phone_number == "some updated phone_number"
      assert boost.price == 43
    end

    test "update_boost/2 with invalid data returns error changeset" do
      boost = boost_fixture()
      assert {:error, %Ecto.Changeset{}} = Boosts.update_boost(boost, @invalid_attrs)
      assert boost == Boosts.get_boost!(boost.id)
    end

    test "delete_boost/1 deletes the boost" do
      boost = boost_fixture()
      assert {:ok, %Boost{}} = Boosts.delete_boost(boost)
      assert_raise Ecto.NoResultsError, fn -> Boosts.get_boost!(boost.id) end
    end

    test "change_boost/1 returns a boost changeset" do
      boost = boost_fixture()
      assert %Ecto.Changeset{} = Boosts.change_boost(boost)
    end
  end
end

defmodule LipiaNgoma.MixtapesTest do
  use LipiaNgoma.DataCase

  alias LipiaNgoma.Mixtapes

  describe "mixtapes" do
    alias LipiaNgoma.Mixtapes.Mixtape

    import LipiaNgoma.MixtapesFixtures

    @invalid_attrs %{status: nil}

    test "list_mixtapes/0 returns all mixtapes" do
      mixtape = mixtape_fixture()
      assert Mixtapes.list_mixtapes() == [mixtape]
    end

    test "get_mixtape!/1 returns the mixtape with given id" do
      mixtape = mixtape_fixture()
      assert Mixtapes.get_mixtape!(mixtape.id) == mixtape
    end

    test "create_mixtape/1 with valid data creates a mixtape" do
      valid_attrs = %{status: "some status"}

      assert {:ok, %Mixtape{} = mixtape} = Mixtapes.create_mixtape(valid_attrs)
      assert mixtape.status == "some status"
    end

    test "create_mixtape/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Mixtapes.create_mixtape(@invalid_attrs)
    end

    test "update_mixtape/2 with valid data updates the mixtape" do
      mixtape = mixtape_fixture()
      update_attrs = %{status: "some updated status"}

      assert {:ok, %Mixtape{} = mixtape} = Mixtapes.update_mixtape(mixtape, update_attrs)
      assert mixtape.status == "some updated status"
    end

    test "update_mixtape/2 with invalid data returns error changeset" do
      mixtape = mixtape_fixture()
      assert {:error, %Ecto.Changeset{}} = Mixtapes.update_mixtape(mixtape, @invalid_attrs)
      assert mixtape == Mixtapes.get_mixtape!(mixtape.id)
    end

    test "delete_mixtape/1 deletes the mixtape" do
      mixtape = mixtape_fixture()
      assert {:ok, %Mixtape{}} = Mixtapes.delete_mixtape(mixtape)
      assert_raise Ecto.NoResultsError, fn -> Mixtapes.get_mixtape!(mixtape.id) end
    end

    test "change_mixtape/1 returns a mixtape changeset" do
      mixtape = mixtape_fixture()
      assert %Ecto.Changeset{} = Mixtapes.change_mixtape(mixtape)
    end
  end
end

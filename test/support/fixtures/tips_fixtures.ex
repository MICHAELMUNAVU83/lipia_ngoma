defmodule LipiaNgoma.TipsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LipiaNgoma.Tips` context.
  """

  @doc """
  Generate a tip.
  """
  def tip_fixture(attrs \\ %{}) do
    {:ok, tip} =
      attrs
      |> Enum.into(%{
        name: "some name",
        phone_number: "some phone_number",
        price: 42,
        tipid: "some tipid"
      })
      |> LipiaNgoma.Tips.create_tip()

    tip
  end
end

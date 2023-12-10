defmodule LipiaNgoma.BoostsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LipiaNgoma.Boosts` context.
  """

  @doc """
  Generate a boost.
  """
  def boost_fixture(attrs \\ %{}) do
    {:ok, boost} =
      attrs
      |> Enum.into(%{
        name: "some name",
        phone_number: "some phone_number",
        price: 42
      })
      |> LipiaNgoma.Boosts.create_boost()

    boost
  end
end

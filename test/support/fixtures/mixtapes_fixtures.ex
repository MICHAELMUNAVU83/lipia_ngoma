defmodule LipiaNgoma.MixtapesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LipiaNgoma.Mixtapes` context.
  """

  @doc """
  Generate a mixtape.
  """
  def mixtape_fixture(attrs \\ %{}) do
    {:ok, mixtape} =
      attrs
      |> Enum.into(%{
        status: "some status"
      })
      |> LipiaNgoma.Mixtapes.create_mixtape()

    mixtape
  end
end

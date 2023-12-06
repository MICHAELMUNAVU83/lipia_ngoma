defmodule LipiaNgoma.PayoutsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LipiaNgoma.Payouts` context.
  """

  @doc """
  Generate a payout.
  """
  def payout_fixture(attrs \\ %{}) do
    {:ok, payout} =
      attrs
      |> Enum.into(%{
        name: "some name",
        amount: 42,
        phone_number: "some phone_number",
        payoutid: "some payoutid"
      })
      |> LipiaNgoma.Payouts.create_payout()

    payout
  end
end

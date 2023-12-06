defmodule LipiaNgoma.Payouts.Payout do
  use Ecto.Schema
  import Ecto.Changeset

  schema "payouts" do
    field :name, :string
    field :amount, :integer
    field :phone_number, :string
    field :payoutid, :string
    belongs_to :user, LipiaNgoma.Users.User
    timestamps()
  end

  @doc false
  def changeset(payout, attrs) do
    payout
    |> cast(attrs, [:name, :phone_number, :amount, :payoutid, :user_id])
    |> validate_required([:name, :phone_number, :amount, :payoutid, :user_id])
  end
end

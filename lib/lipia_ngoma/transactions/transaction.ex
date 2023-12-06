defmodule LipiaNgoma.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :message, :string
    field :status, :integer
    field :success, :boolean, default: false
    field :amount, :string
    field :transaction_code, :string
    field :transaction_reference, :string
    field :phone_number, :string
    belongs_to :user, LipiaNgoma.Users.User

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [
      :message,
      :amount,
      :status,
      :success,
      :transaction_code,
      :transaction_reference,
      :phone_number,
      :user_id
    ])
    |> validate_required([
      :message,
      :amount,
      :status,
      :success,
      :transaction_reference,
      :phone_number,
      :user_id
    ])
  end
end

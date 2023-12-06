defmodule LipiaNgomaWeb.TransactionController do
  use LipiaNgomaWeb, :controller

  alias LipiaNgoma.Transactions
  alias LipiaNgoma.Transactions.Transaction
  alias LipiaNgoma.TransactionAlgorithim

  action_fallback LipiaNgomaWeb.FallbackController

  def index(conn, _params) do
    transactions = Transactions.list_transactions()
    render(conn, "index.json", transactions: transactions)
  end

  def create(conn, transaction_params) do
    phone_number =
      TransactionAlgorithim.decode_phone_number_from_transaction(
        transaction_params["transaction_reference"]
      )

    user_id =
      TransactionAlgorithim.decode_user_id_from_transaction(
        transaction_params["transaction_reference"]
      )

    new_transaction_params = %{
      "message" => transaction_params["Message"],
      "success" => transaction_params["Success"],
      "status" => transaction_params["Status"],
      "amount" => transaction_params["Amount"],
      "transaction_code" => transaction_params["transaction_code"],
      "phone_number" => phone_number,
      "user_id" => user_id,
      "transaction_reference" => transaction_params["transaction_reference"]
    }

    with {:ok, %Transaction{} = transaction} <-
           Transactions.create_transaction(new_transaction_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.transaction_path(conn, :show, transaction))
      |> render("show.json", transaction: transaction)
    end
  end

  def show(conn, %{"id" => id}) do
    transaction = Transactions.get_transaction!(id)
    render(conn, "show.json", transaction: transaction)
  end

  def update(conn, %{"id" => id, "transaction" => transaction_params}) do
    transaction = Transactions.get_transaction!(id)

    with {:ok, %Transaction{} = transaction} <-
           Transactions.update_transaction(transaction, transaction_params) do
      render(conn, "show.json", transaction: transaction)
    end
  end

  def delete(conn, %{"id" => id}) do
    transaction = Transactions.get_transaction!(id)

    with {:ok, %Transaction{}} <- Transactions.delete_transaction(transaction) do
      send_resp(conn, :no_content, "")
    end
  end
end

defmodule LipiaNgoma.Chpter do
  @moduledoc """
  Documentation for `Chpter`.
  """

  @doc """
  Initiates the Stk Push request to USing Chpter API

  This function takes in the following parameters:

  - `api_key` - Your Chpter API key
  - `phone_number` - The phone number to send the payment request to
  - `name` - The name of the person to send the payment request to
  - `email` - The email of the person to send the payment request to
  - `amount` - The amount to be paid
  - `callback_url` - The callback url to be used by Chpter to send the payment request response to
  - `transaction_reference` - The reference to be used for the payment request

  ```


  Replace the api_key with your Chpter API key , the phone number with the phone number to send the payment request to, the name with the name of the person to send the payment request to, the email with the email of the person to send the payment request to, the amount with the amount to be paid, the callback_url with the callback url to be used by Chpter to send the payment request response to and the transaction_reference with the reference to be used for the payment request.




  ## Examples

       iex> Chpter.initiate_payment(
         "pk_0b51e48bc6ac135ce3f65b1355248cae71ef085c0223bc0273535a4e174dce07",
          "254740769596",
         "Michael Munavu",
         "michaelmunavu83@gmail.com",
         1,
         "Nairobi",
         "https://720a-102-135-173-116.ngrok-free.app/api/transactions",
          "transaction_123456"

      )

  """
  def initiate_payment(
        api_key,
        phone_number,
        name,
        email,
        amount,
        location,
        transaction_reference
      ) do
    header = header(api_key)

    body =
      body(
        phone_number,
        email,
        name,
        location,
        amount,
        transaction_reference
      )

    url = "https://api.chpter.co/v1/initiate/mpesa-payment"

    request_body = Jason.encode!(body)

    HTTPoison.post(url, request_body, header)
  end

  @doc """
  This is the header for the Chpter API request
  This function takes an api_key as a parameter

  ```
  Replace the `api_key` with your Chpter API key
  ```
  """

  defp header(api_key) do
    [
      {
        "Content-Type",
        "application/json"
      },
      {
        "Api-Key",
        api_key
      }
    ]
  end

  @doc """
  This is the body for the Chpter API request
  This function takes the following parameters:
  - `phone_number` - The phone number to send the payment request to
  - `name` - The name of the person to send the payment request to
  - `email` - The email of the person to send the payment request to
  - `amount` - The amount to be paid
  - `callback_url` - The callback url to be used by Chpter to send the payment request response to
  - `transaction_reference` - The reference to be used for the payment request



  """

  defp body(
         phone_number,
         email,
         name,
         location,
         amount,
         transaction_reference
       ) do
    %{
      customer_details: %{
        "full_name" => name,
        "location" => location,
        "phone_number" => phone_number,
        "email" => email
      },
      products: [],
      amount: %{
        "currency" => "KES",
        "delivery_fee" => 0.0,
        "discount_fee" => 0.0,
        "total" => amount
      },
      callback_details: %{
        "transaction_reference" => transaction_reference,
        "callback_url" => get_api_endpoint()
      }
    }
  end

  @doc """

  This function checks for the payment status from the Chpter API
  This is a recursive function that takes the following parameters:
  - `transaction_reference` - The reference to be used for the payment request

  - `api_endpoint` - The Chpter API endpoint where all the transactions are stored

  ```

  Replace the `transaction_reference` with the reference to be used for the payment request
   and the `api_endpoint` with the endpoint to be used to check for the payment status


  Replace the api_key with your Chpter API key , the phone number with the phone number
   to send the payment request to, the name with the name of the person to send the payment request to,
   the email with the email of the person to send the payment request to, the amount with the amount to be paid,
   the callback_url with the callback url to be used by Chpter to send the payment request response to and the transaction_reference
    with the reference to be used for the payment request.




  ## Examples

       iex> Chpter.check_for_payment("transaction_123456", "https://api.chpter.co/v1/transactions")

  ```
  """

  def check_for_payment(transaction_reference) do
    api_endpoint = get_api_endpoint()
    body = HTTPoison.get!(api_endpoint)

    customer_record =
      Jason.decode!(body.body)["data"]
      |> Enum.find(fn record -> record["transaction_reference"] == transaction_reference end)

    customer_record

    if customer_record != nil do
      customer_record
    else
      Process.sleep(1000)
      check_for_payment(transaction_reference)
    end
  end

  def get_api_endpoint do
    "https://e9da-102-135-174-116.ngrok-free.app/api/transactions"
  end

  @doc """

  This function allows you to withdraw money from a Chpter account to a mobile wallet , in this case mpesa.
  This function takes the following parameters:
  - `name` - The name of the person to send the payment request to
  - `email` - The email of the person to send the payment request to
  - `phone_number` - The phone number to send the payment request to
  - `amount` - The amount to be paid as an integer
  - `callback_url` - The callback url to be used by Chpter to send the payment request response to
  - `payout_reference` - The reference to be used for the payment request
  - `api_key` - Your Chpter API key



  ```

  Replace the `payout_reference` with the reference to be used for the payment request
   and the `callback_url` with the url that chpter will send the response to .

   A successful response will be as follows:

   ```
   {
    "message": "Success",
    "success": true,
    "status": 200,
    "amount": 100,
    "currency": "KES",
    "payout_reference": "ABCD123",
  }
    ```

    A failed response will be as follows:

    ```
    {
    "message": "Payout failed contact support@chpter.co",
    "success": false,
    "status": 200,
    "payout_reference": "ABCD123",
  }
    ```
    Replace the api_key with your Chpter API key for the account you want to withdraw from .
    The amount is an integer and has to be a minimum of 20  KES .


  ## Examples

       iex> Chpter.withdraw(
         "Michael Munavu",
         "michaelmunavu83@gmail.com",
         "254740769596",
         25,
          "https://720a-102-135-173-116.ngrok-free.app/api/transactions",
          "ABCD123",
          "pk_0b51e48bc6ac135ce3f65b1355248cae71ef085c0223bc0273535a4e174dce07"
      )


  ```
  """

  def withdraw(name, email, phone_number, amount, callback_url, payout_reference, api_key) do
    header = header(api_key)
    url = "https://api.chpter.co/v1/payout/mobile-wallet"

    body = withdrawal_body(name, email, phone_number, amount, callback_url, payout_reference)

    request_body = Jason.encode!(body)

    HTTPoison.post(url, request_body, header)
  end

  defp withdrawal_body(name, email, phone_number, amount, callback_url, payout_reference) do
    %{
      client_details: %{
        "full_name" => name,
        "phone_number" => phone_number,
        "email" => email
      },
      destination_details: %{
        "country_code" => "KE",
        "mobile_number" => phone_number,
        "wallet_type" => "mpesa"
      },
      transfer_details: %{
        "currency_code" => "KES",
        "amount" => amount
      },
      callback_details: %{
        "notify_customer" => true,
        "payout_reference" => payout_reference,
        "callback_url" => callback_url
      }
    }
  end
end

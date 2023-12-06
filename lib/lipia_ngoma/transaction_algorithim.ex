defmodule LipiaNgoma.TransactionAlgorithim do
  def code_reference_for_transaction(user, phone_number) do
    timestamp =
      Timex.local()
      |> Timex.format!("{YYYY}{0M}{0D}{h24}{m}{s}")

    first_six_numbers = String.slice(phone_number, 0..5)
    last_six_numbers = String.slice(phone_number, 6..12)

    first_four_timestamp_numbers = String.slice(timestamp, 0..3)
    last_ten_timestamp_numbers = String.slice(timestamp, 4..14)

    user <>
      first_four_timestamp_numbers <>
      last_six_numbers <> last_ten_timestamp_numbers <> first_six_numbers
  end

  def decode_user_id_from_transaction(transaction) do
    case String.length(transaction) == 27 do
      true ->
        String.slice(transaction, 0..0)

      false ->
        String.slice(transaction, 0..(String.length(transaction) - 27))
    end
  end

  def decode_phone_number_from_transaction(transaction) do
    transaction_ref_without_user_id =
      case String.length(transaction) == 27 do
        true ->
          String.slice(transaction, 1..26)

        false ->
          String.slice(
            transaction,
            (String.length(transaction) - 26)..(String.length(transaction) - 1)
          )
      end

    last_six_numbers = String.slice(transaction_ref_without_user_id, 4..9)

    first_six_numbers = String.slice(transaction_ref_without_user_id, 20..25)

    first_six_numbers <> last_six_numbers
  end
end

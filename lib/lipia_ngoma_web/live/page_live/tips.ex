defmodule LipiaNgomaWeb.PageLive.Tips do
  use LipiaNgomaWeb, :live_view
  alias LipiaNgoma.Users
  alias LipiaNgoma.Tips.Tip
  alias LipiaNgoma.Chpter
  alias LipiaNgoma.TransactionAlgorithim
  alias LipiaNgoma.Tips

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, %{"username" => username}) do
    user = Users.get_user_by_username(username)

    tips = Users.get_user_tips(username)

    socket
    |> assign(:user, user)
    |> assign(:tip, %Tip{})
    |> assign(:changeset, Tips.change_tip(%Tip{}))
    |> assign(
      :return_to,
      Routes.page_tip_success_path(socket, :index, user.username)
    )
    |> assign(:tips, tips)
    |> assign(:page_title, "Add tips for #{username} Home Page")
  end

  def handle_event("validate", %{"tip" => tip_params}, socket) do
    changeset =
      socket.assigns.tip
      |> Tips.change_tip(tip_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"tip" => tip_params}, socket) do
    transaction_reference =
      TransactionAlgorithim.code_reference_for_transaction(
        Integer.to_string(socket.assigns.user.id),
        tip_params["phone_number"]
      )

    case Chpter.initiate_payment(
           "pk_ed5555e00579aaa99fa4a9ed6b8078559256e3987730e737bdcf9334ead73a51",
           tip_params["phone_number"],
           tip_params["name"],
           "test@gmail.com",
           String.to_integer(tip_params["price"]),
           "Nairobi",
           transaction_reference
         ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        customer_record =
          Chpter.check_for_payment(transaction_reference)

        new_tip_params =
          tip_params
          |> Map.put("tipid", transaction_reference)

        if customer_record["success"] == true do
          case Tips.create_tip(tip_params) do
            {:ok, _tip} ->
              {:noreply,
               socket
               |> push_redirect(to: socket.assigns.return_to)}

            {:error, %Ecto.Changeset{} = changeset} ->
              {:noreply, assign(socket, changeset: changeset)}
          end
        else
          {:noreply,
           socket
           |> put_flash(:error, "Payment Failed , #{customer_record["message"]}")}
        end

      {:error, %HTTPoison.Error{reason: :timeout, id: nil}} ->
        customer_record =
          Chpter.check_for_payment(transaction_reference)

        new_tip_params =
          tip_params
          |> Map.put("tipid", transaction_reference)

        if customer_record["success"] == true do
          case Tips.create_tip(tip_params) do
            {:ok, _tip} ->
              {:noreply,
               socket
               |> push_redirect(to: socket.assigns.return_to)}

            {:error, %Ecto.Changeset{} = changeset} ->
              {:noreply, assign(socket, changeset: changeset)}
          end
        else
          {:noreply,
           socket
           |> put_flash(:error, "Payment Failed , #{customer_record["message"]}")}
        end

      {:ok, %HTTPoison.Response{status_code: 400, body: body}} ->
        {:noreply,
         socket
         |> put_flash(:error, "Payment Failed")}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:noreply,
         socket
         |> put_flash(:error, "Payment Failed , Timeout error")}
    end
  end
end

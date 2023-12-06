defmodule LipiaNgoma.Repo do
  use Ecto.Repo,
    otp_app: :lipia_ngoma,
    adapter: Ecto.Adapters.MyXQL
end

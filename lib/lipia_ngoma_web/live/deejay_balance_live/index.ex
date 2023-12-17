defmodule LipiaNgomaWeb.DeejayBalanceLive.Index do
  use LipiaNgomaWeb, :deejay_live_view
  alias LipiaNgoma.Users
  alias LipiaNgoma.Dashboard

  def mount(_params, session, socket) do
    current_user =
      Users.get_user_by_session_token(session["user_token"])

    tips = Dashboard.get_tips_amount_for_a_user(current_user.id)
    song_requests = Dashboard.get_song_request_money_for_a_user(current_user.id)
    spotify_playlists = Dashboard.get_spotify_playlist_money_for_a_user(current_user.id)
    mixtapes = Dashboard.get_mixtape_money_for_a_dj(current_user.id)
    money_withdrawn = Dashboard.get_money_withdrawn(current_user.id)
    commission = Dashboard.get_commission_for_a_dj(current_user.id)
    money_in_wallet = Dashboard.get_money_in_wallet_for_a_dj(current_user.id)

    {:ok,
     socket
     |> assign(:tips, tips)
     |> assign(:song_requests, song_requests)
     |> assign(:spotify_playlists, spotify_playlists)
     |> assign(:mixtapes, mixtapes)
     |> assign(:money_withdrawn, money_withdrawn)
     |> assign(:commission, commission)
     |> assign(:money_in_wallet, money_in_wallet)
     |> assign(:current_user, current_user)}
  end
end

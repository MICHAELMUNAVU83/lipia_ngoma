defmodule LipiaNgoma.Dashboard do
  alias LipiaNgoma.Tips
  alias LipiaNgoma.SongRequests
  alias LipiaNgoma.SpotifyPlaylists
  alias LipiaNgoma.Mixtapes
  alias LipiaNgoma.Payouts

  def get_tips_amount_for_a_user(id) do
    Tips.list_tips_amount_for_a_user(id)
    |> Decimal.to_integer()
  end

  def get_song_request_money_for_a_user(id) do
    SongRequests.get_total_song_request_money_for_a_user(id)
    |> Decimal.to_integer()
  end

  def get_spotify_playlist_money_for_a_user(id) do
    SpotifyPlaylists.get_total_spotify_playlist_money_for_a_user(id)
    |> Decimal.to_integer()
  end

  def get_mixtape_money_for_a_dj(id) do
    Mixtapes.get_mixtape_money_for_a_dj(id)
    |> Decimal.to_integer()
  end

  def get_money_withdrawn(id) do
    Payouts.get_money_withdrawn_by_a_dj(id)
    |> Decimal.to_integer()
  end

  def get_commission_for_a_dj(id) do
    (0.1 *
       (get_tips_amount_for_a_user(id) +
          get_song_request_money_for_a_user(id) +
          get_spotify_playlist_money_for_a_user(id) +
          get_mixtape_money_for_a_dj(id) -
          get_money_withdrawn(id)))
    |> Float.round(0)
   
  end

  def get_money_in_wallet_for_a_dj(id) do
    get_tips_amount_for_a_user(id) +
      get_song_request_money_for_a_user(id) +
      get_spotify_playlist_money_for_a_user(id) +
      get_mixtape_money_for_a_dj(id) -
      get_money_withdrawn(id) -
      get_commission_for_a_dj(id)
  end
end

defmodule LipiaNgomaWeb.DeejayDashboardLive.Index do
  use LipiaNgomaWeb, :deejay_live_view
  alias LipiaNgoma.Users
  alias LipiaNgoma.Dashboard
  alias LipiaNgoma.Tips
  alias LipiaNgoma.SongRequests
  alias LipiaNgoma.SpotifyPlaylists
  alias LipiaNgoma.Mixtapes

  def mount(_params, session, socket) do
    current_user = Users.get_user_by_session_token(session["user_token"])
    tips = Dashboard.get_tips_amount_for_a_user(current_user.id)
    song_requests = Dashboard.get_song_request_money_for_a_user(current_user.id)
    spotify_playlists = Dashboard.get_spotify_playlist_money_for_a_user(current_user.id)
    mixtapes = Dashboard.get_mixtape_money_for_a_dj(current_user.id)

    number_of_tips_for_a_user = length(Tips.list_tips_for_a_user(current_user.id))

    number_of_song_requests_for_a_user =
      length(SongRequests.list_completed_song_requests_for_a_user(current_user.id))

    number_of_spotify_playlists_for_a_user =
      length(SpotifyPlaylists.get_spotify_playlists_for_a_user(current_user.id))

    number_of_mixtapes_for_a_user = length(Mixtapes.get_mixtapes_for_a_dj(current_user.id))

    {:ok,
     socket
     |> assign(:tips, tips)
     |> assign(:song_requests, song_requests)
     |> assign(:spotify_playlists, spotify_playlists)
     |> assign(:mixtapes, mixtapes)
     |> assign(:number_of_tips_for_a_user, number_of_tips_for_a_user)
     |> assign(:number_of_song_requests_for_a_user, number_of_song_requests_for_a_user)
     |> assign(:number_of_spotify_playlists_for_a_user, number_of_spotify_playlists_for_a_user)
     |> assign(:number_of_mixtapes_for_a_user, number_of_mixtapes_for_a_user)
     |> assign(:current_user, current_user)}
  end
end

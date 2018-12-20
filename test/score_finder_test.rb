require 'minitest/autorun'
require 'minitest/pride'
require './lib/score_finder'
require './lib/stat_tracker'

class ScoreFinderTest < Minitest::Test
  def setup
    game_path = './data/game_sample.csv'
    team_path = './data/team_info_sample.csv'
    game_teams_path = './data/game_teams_stats_sample.csv'

    @locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
  end

  def test_it_can_generate_a_hash_of_team_ids_and_games
    stat_tracker = StatTracker.from_csv(@locations)

    expected = {3=>5, 6=>6, 19=>1, 23=>1, 24=>2, 4=>1, 29=>2, 12=>1, 17=>1}

    assert_equal expected, stat_tracker.generate_number_of_games_by_team_id(stat_tracker.game_teams)
  end
end

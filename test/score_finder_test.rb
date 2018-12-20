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

  def test_it_can_generate_a_hash_of_team_ids_and_games_played
    stat_tracker = StatTracker.from_csv(@locations)

    expected = {3=>5, 6=>6, 19=>1, 23=>1, 24=>2, 4=>1, 29=>2, 12=>1, 17=>1}

    assert_equal expected, stat_tracker.generate_number_of_games_by_team_id(stat_tracker.game_teams)
  end

  def test_it_can_generate_a_hash_of_team_ids_defaulting_to_a_0_value
    stat_tracker = StatTracker.from_csv(@locations)

    expected = {3=>0, 6=>0, 19=>0, 23=>0, 24=>0, 4=>0, 29=>0, 12=>0, 17=>0}

    assert_equal expected, stat_tracker.generate_scores_by_team_id(stat_tracker.game_teams)
  end

  def test_it_can_add_home_and_away_goals
    stat_tracker = StatTracker.from_csv(@locations)
    team_scores_by_id = {3=>0, 6=>0, 19=>0, 23=>0, 24=>0, 4=>0, 29=>0, 12=>0, 17=>0}

    expected_home = {3=>5, 6=>17, 19=>0, 23=>2, 24=>3, 4=>2, 29=>4, 12=>0, 17=>0}
    expected_away = {3=>5, 6=>5, 19=>1, 23=>0, 24=>3, 4=>0, 29=>2, 12=>2, 17=>2}

    assert_equal expected_home, stat_tracker.add_goals_by_home_or_away("home", team_scores_by_id)
    assert_equal expected_away, stat_tracker.add_goals_by_home_or_away("away", team_scores_by_id)
  end

  def test_it_can_return_a_hash_of_average_goals_per_team


  end
end

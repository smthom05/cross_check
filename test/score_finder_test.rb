require './test/test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/stat_tracker'

class ScoreFinderTest < Minitest::Test
  def setup
    game_path = './test/data/game_sample.csv'
    team_path = './test/data/team_info_sample.csv'
    game_teams_path = './test/data/game_teams_stats_sample.csv'

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
    expected_away = {3=>10, 6=>22, 19=>1, 23=>2, 24=>6, 4=>2, 29=>6, 12=>2, 17=>2}

    assert_equal expected_home, stat_tracker.add_goals_by_home_or_away("home", team_scores_by_id)
    assert_equal expected_away, stat_tracker.add_goals_by_home_or_away("away", team_scores_by_id)
  end

  def test_it_can_return_a_hash_of_average_goals_per_team
    stat_tracker = StatTracker.from_csv(@locations)
    goals_hash = {3=>5, 6=>17, 19=>0, 23=>2, 24=>3, 4=>2, 29=>4, 12=>0, 17=>0}
    games_hash = {3=>5, 6=>6, 19=>1, 23=>1, 24=>2, 4=>1, 29=>2, 12=>1, 17=>1}

    expected = {3=>1.0, 6=>2.8333333333333335, 19=>0.0, 23=>2.0, 24=>1.5, 4=>2.0, 29=>2.0, 12=>0.0, 17=>0.0}

    assert_equal expected, stat_tracker.average_goals_per_game_by_team(goals_hash, games_hash)
  end

  def test_it_can_return_the_highest_and_lowest_scoring_teams
    stat_tracker = StatTracker.from_csv(@locations)
    average_hash = {3=>1.0, 6=>2.8333333333333335, 19=>0.0, 23=>2.0, 24=>1.5, 4=>2.0, 29=>2.0, 12=>0.0, 17=>0.0}

    assert_equal "Bruins", stat_tracker.highest_scoring_team(average_hash)
    assert_equal "Red Wings", stat_tracker.lowest_scoring_team(average_hash)
  end
end

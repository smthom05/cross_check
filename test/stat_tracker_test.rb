require 'minitest/autorun'
require 'simplecov'
require './lib/stat_tracker'
SimpleCov.start

class StatTrackerTest < Minitest::Test
  def setup
    game_path = './data/game.csv'
    team_path = './data/team_info.csv'
    game_teams_path = './data/game_teams_stats.csv'

    @locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
  end

  def test_it_exists
    stat_tracker = StatTracker.from_csv_test(@locations)
    assert_instance_of StatTracker, stat_tracker
  end

  def test_it_can_determine_most_popular_venue
    stat_tracker = StatTracker.from_csv_test(@locations)

    assert_equal "United Center", stat_tracker.most_popular_venue
  end

  def test_it_can_determine_least_popular_venue
    stat_tracker = StatTracker.from_csv_test(@locations)

    assert_equal "Scotiabank Place", stat_tracker.least_popular_venue
  end

  def test_it_can_determine_season_with_most_games
    stat_tracker = StatTracker.from_csv_test(@locations)

    #full csv gives back 20172018
    assert_equal 20122013, stat_tracker.season_with_most_games
  end

  def test_it_can_determine_season_with_fewest_games
    stat_tracker = StatTracker.from_csv_test(@locations)

    #full csv gives back 20122013
    assert_equal 20162017, stat_tracker.season_with_fewest_games
  end
end

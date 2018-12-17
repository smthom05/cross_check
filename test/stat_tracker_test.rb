require 'minitest/autorun'
require 'simplecov'
require './lib/stat_tracker'
SimpleCov.start

class StatTrackerTest < Minitest::Test
  def test_it_exists
    stat_tracker = StatTracker.new
    assert_instance_of StatTracker, stat_tracker
  end

  def test_it_can_be_created_from_csv
    stat_tracker = StatTracker.from_csv_test("./data/game_teams_stats.csv")
    first_game = ["2012030221", "3", "away", "FALSE", "OT", "John Tortorella", "2", "35", "44", "8", "3", "0", "44.8", "17", "7"]
    assert_equal first_game, stat_tracker[0]
  end

  def test_highest_total_score
  end
end

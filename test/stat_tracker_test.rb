require 'minitest/autorun'
require 'minitest/pride'
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

  def test_it_knows_highest_total_score
    stat_tracker = StatTracker.from_csv_test(@locations)

    assert_instance_of Integer, stat_tracker.highest_total_score
    assert_equal 11, stat_tracker.highest_total_score
  end

  def test_it_knows_lowest_total_score
    stat_tracker = StatTracker.from_csv_test(@locations)

    assert_instance_of Integer, stat_tracker.lowest_total_score
    assert_equal 0, stat_tracker.lowest_total_score
  end

  def test_it_knows_biggest_blowout
    stat_tracker = StatTracker.from_csv_test(@locations)

    assert_instance_of Integer, stat_tracker.biggest_blowout
    assert_equal 5, stat_tracker.biggest_blowout
  end

  def test_it_knows_games_by_season
    stat_tracker = StatTracker.from_csv_test(@locations)

    assert_instance_of Hash, stat_tracker.count_of_games_by_season
    assert_equal ({"20122013"=>57, "20162017"=>4, "20142015"=>17, "20152016"=>16, "20132014"=>6}), stat_tracker.count_of_games_by_season
  end

  def test_it_can_determine_percentage_home_wins
    stat_tracker = StatTracker.from_csv_test(@locations)
    assert_equal 70.0, stat_tracker.percentage_home_wins
  end

  def test_it_can_determine_percentage_visitor_wins
    stat_tracker = StatTracker.from_csv_test(@locations)
    assert_equal 30.0, stat_tracker.percentage_visitor_wins
  end

  def test_it_can_determine_average_goals_per_game
    stat_tracker = StatTracker.from_csv_test(@locations)
    assert_equal 4.97, stat_tracker.average_goals_per_game
  end

  def test_it_can_determine_average_goals_by_season
    stat_tracker = StatTracker.from_csv_test(@locations)
    hash = {"20122013"=>4.912280701754386, "20162017"=>5.75, "20142015"=>4.823529411764706, "20152016"=>4.875, "20132014"=>5.666666666666667}
    assert_equal hash, stat_tracker.average_goals_by_season
  end

  def test_it_knows_wins_and_losses
    stat_tracker = StatTracker.from_csv_test(@locations)

    assert_equal false, stat_tracker.game_teams[0].won?
    assert_equal true, stat_tracker.game_teams[1].won?
  end

  def test_it_knows_highest_scoring_home_team
    stat_tracker = StatTracker.from_csv_test(@locations)

    assert_equal "Islanders", stat_tracker.highest_scoring_home_team
  end

  def test_it_knows_lowest_scoring_home_team
    stat_tracker = StatTracker.from_csv_test(@locations)

    assert_equal "Wild", stat_tracker.lowest_scoring_home_team
  end

  def test_it_knows_highest_scoring_away_team
    stat_tracker = StatTracker.from_csv_test(@locations)

    assert_equal "Senators", stat_tracker.highest_scoring_visitor
  end

  def test_it_knows_lowest_scoring_away_team
    stat_tracker = StatTracker.from_csv_test(@locations)

    assert_equal "Canadiens", stat_tracker.lowest_scoring_visitor
  end
end

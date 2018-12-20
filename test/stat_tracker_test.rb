require './test/test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/stat_tracker'

class StatTrackerTest < Minitest::Test
  def setup
    game_path = './data/game_sample.csv'
    team_path = './data/team_info.csv'
    game_teams_path = './data/game_teams_stats_sample.csv'

    @locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
  end

  def test_it_exists
    stat_tracker = StatTracker.from_csv(@locations)

    assert_instance_of StatTracker, stat_tracker
  end

  def test_it_can_determine_most_popular_venue
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal "TD Garden", stat_tracker.most_popular_venue
  end

  def test_it_can_determine_least_popular_venue
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal "United Center", stat_tracker.least_popular_venue
  end

  def test_it_can_determine_season_with_most_games
    stat_tracker = StatTracker.from_csv(@locations)

    #full csv gives back 20172018
    assert_equal 20122013, stat_tracker.season_with_most_games
  end

  def test_it_can_determine_season_with_fewest_games
    stat_tracker = StatTracker.from_csv(@locations)

    #full csv gives back 20122013
    assert_equal 20122013, stat_tracker.season_with_fewest_games
  end

  def test_it_knows_highest_total_score
    stat_tracker = StatTracker.from_csv(@locations)

    assert_instance_of Integer, stat_tracker.highest_total_score
    assert_equal 7, stat_tracker.highest_total_score
  end

  def test_it_knows_lowest_total_score
    stat_tracker = StatTracker.from_csv(@locations)

    assert_instance_of Integer, stat_tracker.lowest_total_score
    assert_equal 0, stat_tracker.lowest_total_score
  end

  def test_it_knows_biggest_blowout
    stat_tracker = StatTracker.from_csv(@locations)

    assert_instance_of Integer, stat_tracker.biggest_blowout
    assert_equal 3, stat_tracker.biggest_blowout
  end

  def test_it_knows_games_by_season
    stat_tracker = StatTracker.from_csv(@locations)

    assert_instance_of Hash, stat_tracker.count_of_games_by_season
    assert_equal ({20122013=>10}), stat_tracker.count_of_games_by_season
  end

  def test_it_can_determine_from_csv_wins
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal 80.0, stat_tracker.percentage_home_wins
  end

  def test_it_can_determine_percentage_visitor_wins
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal 20.0, stat_tracker.percentage_visitor_wins
  end

  def test_it_can_determine_average_goals_per_game
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal 4.5, stat_tracker.average_goals_per_game
  end

  def test_it_can_determine_average_goals_by_season
    stat_tracker = StatTracker.from_csv(@locations)
    hash = {20122013=>4.5}

    assert_equal hash, stat_tracker.average_goals_by_season
  end


  def test_it_can_determine_best_offense
    stat_tracker = StatTracker.from_csv(@locations)
    assert_equal "Bruins", stat_tracker.best_offense
  end

  def test_it_can_determine_worst_offense
    stat_tracker = StatTracker.from_csv(@locations)
    assert_equal "Devils", stat_tracker.worst_offense
  end

  def test_it_can_determine_best_defense
    stat_tracker = StatTracker.from_csv(@locations)
    assert_equal "Kings", stat_tracker.best_defense
  end

  def test_it_can_determine_worst_defense
    stat_tracker = StatTracker.from_csv(@locations)
    assert_equal "Coyotes", stat_tracker.worst_defense
  end

  def test_it_can_count_teams
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal 33, stat_tracker.count_of_teams
  end

  def test_it_can_determine_winningest_team
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal "Bruins", stat_tracker.winningest_team
  end

  def test_it_can_determine_best_fans
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal "Bruins", stat_tracker.best_fans
  end

  def test_it_can_determine_worst_fans
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal [], stat_tracker.worst_fans
  end
end

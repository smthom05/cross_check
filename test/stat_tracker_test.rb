require './test/test_helper'
require './lib/stat_tracker'
require './lib/modules/league_stats'

class StatTrackerTest < Minitest::Test
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

  def test_it_exists
    stat_tracker = StatTracker.from_csv(@locations)

    assert_instance_of StatTracker, stat_tracker
  end

  def test_it_can_determine_highest_total_score
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal 9, stat_tracker.highest_total_score
  end

  def test_it_can_determine_lowest_total_score
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal 3, stat_tracker.lowest_total_score
  end

  def test_it_can_determine_biggest_blowout
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal 3, stat_tracker.biggest_blowout
  end

  def test_it_can_determine_most_popular_venue
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal "TD Garden", stat_tracker.most_popular_venue
  end

  def test_it_can_determine_least_popular_venue
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal "TD Garden", stat_tracker.least_popular_venue
  end

  def test_it_can_determine_percentage_home_wins
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal 75.0, stat_tracker.percentage_home_wins
  end

  def test_it_can_determine_percentage_visitor_wins
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal 25.0, stat_tracker.percentage_visitor_wins
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

  def test_it_can_determine_games_by_season
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal ({20122013=>4, 20162017=>4}), stat_tracker.count_of_games_by_season
  end


  def test_it_can_determine_average_goals_per_game
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal 5.5, stat_tracker.average_goals_per_game
  end

  def test_it_can_determine_average_goals_by_season
    stat_tracker = StatTracker.from_csv(@locations)
    hash = {20122013=>5.5, 20162017=>5.5}

    assert_equal hash, stat_tracker.average_goals_by_season
  end

  def test_it_knows_wins_and_losses
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal false, stat_tracker.game_teams[0].won?
    assert_equal true, stat_tracker.game_teams[1].won?
  end

  def test_it_knows_highest_scoring_home_team

    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal "Predators", stat_tracker.highest_scoring_home_team
  end

  def test_it_knows_lowest_scoring_home_team
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal "Rangers", stat_tracker.lowest_scoring_home_team
  end

  def test_it_knows_highest_scoring_away_team
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal "Rangers", stat_tracker.highest_scoring_visitor
  end

  def test_it_knows_lowest_scoring_away_team
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal "Predators", stat_tracker.lowest_scoring_visitor
  end

  def test_it_can_determine_best_offense
    stat_tracker = StatTracker.from_csv(@locations)
    assert_equal "Predators", stat_tracker.best_offense
  end

  def test_it_can_determine_worst_offense
    stat_tracker = StatTracker.from_csv(@locations)
    assert_equal "Blues", stat_tracker.worst_offense
  end

  def test_it_can_determine_best_defense
    stat_tracker = StatTracker.from_csv(@locations)
    assert_equal "Predators", stat_tracker.best_defense
  end

  def test_it_can_determine_worst_defense
    stat_tracker = StatTracker.from_csv(@locations)
    assert_equal "Blues", stat_tracker.worst_defense
  end

  def test_it_can_count_teams
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal 4, stat_tracker.count_of_teams
  end

  def test_it_can_determine_winningest_team
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal "Blues", stat_tracker.winningest_team
  end

  def test_it_can_determine_best_fans
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal "Blues", stat_tracker.best_fans
  end

  def test_it_can_determine_worst_fans
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal [], stat_tracker.worst_fans

  end

  def test_it_can_determine_biggest_bust
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal "Bruins", stat_tracker.biggest_bust(20122013)
  end


  def test_it_can_give_average_win_percentage
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal 0.50, stat_tracker.average_win_percentage(6)
  end

  def test_it_can_determine_biggest_surprise
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal "Rangers", stat_tracker.biggest_surprise(20122013)
  end


  def test_it_can_get_team_attributes
    stat_tracker = StatTracker.from_csv(@locations)

    expected = {
      team_id: 19,
      franchise_id: 18,
      short_name: "St Louis",
      team_name: "Blues",
      abbreviation: "STL",
      link: "/api/v1/teams/19"
    }

    assert_equal expected, stat_tracker.team_info(19)
  end


  def test_it_can_create_a_season_summary
    stat_tracker = StatTracker.from_csv(@locations)
    season_summary = {
      preseason: {
        win_percentage: 100.0,
        goals_scored: 5,
        goals_against: 3
      },
      regular_season: {
        win_percentage: 0.0,
        goals_scored: 6,
        goals_against: 8
      }
    }
    assert_equal season_summary, stat_tracker.season_summary(20122013, 6)
  end
#
  def test_it_can_determine_most_goals_scored
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal 6, stat_tracker.most_goals_scored(18)
  end

  def test_it_can_determine_least_goals_scored
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal 1, stat_tracker.least_goals_scored(18)
  end

  def test_it_can_determine_favorite_opponent
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal "Bruins", stat_tracker.favorite_opponent(3)
  end

  def test_it_can_determine_rival
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal "Bruins", stat_tracker.rival(3)
  end

  def test_it_can_determine_biggest_team_blowout
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal 3, stat_tracker.biggest_team_blowout(18)
  end

  def test_it_can_determine_worst_loss
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal 2, stat_tracker.worst_loss(18)
  end

  def test_it_can_give_a_seasonal_summary
    stat_tracker = StatTracker.from_csv(@locations)
    hash = {
      20122013 => {
        preseason: {
          win_percentage: 0.0,
          total_goals_scored: 3,
          total_goals_against: 5,
          average_goals_scored: 1.5,
          average_goals_against: 2.5
        },
        regular_season: {
          win_percentage: 100.0,
          total_goals_scored: 8,
          total_goals_against: 6,
          average_goals_scored: 4.0,
          average_goals_against: 3.0
        }
      }
    }
    assert_equal hash, stat_tracker.seasonal_summary(3)
  end

  def test_it_can_give_head_to_head
    stat_tracker = StatTracker.from_csv(@locations)

    expected = {
      wins: 2,
      losses: 2
    }

    assert_equal expected, stat_tracker.head_to_head(3, 6)
  end

  def test_it_can_determine_best_season
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal 20122013, stat_tracker.best_season(3)
  end

  # def test_it_can_determine_worst_season
  #   stat_tracker = StatTracker.from_csv(@locations)
  #
  #   assert_equal 20122013, stat_tracker.best_season
  # end
end

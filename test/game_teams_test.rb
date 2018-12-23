require './test/test_helper'
require './lib/stat_tracker'
require './lib/game_teams'

class GameTeamsTest < Minitest::Test
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
  game_teams = stat_tracker.game_teams[0]

  assert_instance_of GameTeams, game_teams
  end

  def test_it_has_attributes
    stat_tracker = StatTracker.from_csv(@locations)
    game_teams = stat_tracker.game_teams[0]

    assert_equal 2012030221, game_teams.game_id
    assert_equal 3, game_teams.team_id
    assert_equal "away", game_teams.hoa
    assert_equal "FALSE", game_teams.won
    assert_equal "OT", game_teams.settled_in
    assert_equal "John Tortorella", game_teams.head_coach
    assert_equal 2, game_teams.goals
    assert_equal 35, game_teams.shots
    assert_equal 44, game_teams.hits
    assert_equal 8, game_teams.pim
    assert_equal 3, game_teams.powerPlayOpportunities
    assert_equal 0, game_teams.powerPlayGoals
    assert_equal 44.8, game_teams.faceOffWinPercentage
    assert_equal 17, game_teams.giveaways
    assert_equal 7, game_teams.takeaways
  end
end

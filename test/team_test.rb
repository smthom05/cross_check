require './test/test_helper'
require 'minitest/autorun'
require './lib/stat_tracker'
require './lib/team'

class TeamTest < Minitest::Test
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
    team = stat_tracker.teams[0]

    assert_instance_of Team, team
  end

  def test_it_has_attributes
    stat_tracker = StatTracker.from_csv_test(@locations)
    team = stat_tracker.teams[0]

    assert_equal 1, team.team_id
    assert_equal 23, team.franchise_id
    assert_equal "New Jersey", team.short_name
    assert_equal "Devils", team.team_name
    assert_equal "NJD", team.abbreviation
    assert_equal "/api/v1/teams/1", team.link
  end
end

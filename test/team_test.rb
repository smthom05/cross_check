require './test/test_helper'
require './lib/stat_tracker'
require './lib/team'

class TeamTest < Minitest::Test
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
    team = stat_tracker.teams[0]

    assert_instance_of Team, team
  end

  def test_it_has_attributes
    stat_tracker = StatTracker.from_csv(@locations)
    team = stat_tracker.teams[0]

    assert_equal 3, team.team_id
    assert_equal 10, team.franchise_id
    assert_equal "NY Rangers", team.short_name
    assert_equal "Rangers", team.team_name
    assert_equal "NYR", team.abbreviation
    assert_equal "/api/v1/teams/3", team.link
  end
end

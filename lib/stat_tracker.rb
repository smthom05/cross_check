require 'csv'
class StatTracker
  def self.from_csv_test(locations)
    csv = []
    csv << CSV.readlines(locations[:games])[1, 100]
    csv << CSV.readlines(locations[:teams])[1, 100]
    csv << CSV.readlines(locations[:game_teams])[1, 100]
  end

  def self.from_csv(locations)
    csv = []
    csv << CSV.readlines(locations[:games])
    csv << CSV.readlines(locations[:teams])
    csv << CSV.readlines(locations[:game_teams])
  end
end

game_path = './data/game.csv'
team_path = './data/team_info.csv'
game_teams_path = './data/game_teams_stats.csv'

locations = {
  games: game_path,
  teams: team_path,
  game_teams: game_teams_path
}

stat_tracker = StatTracker.from_csv_test(locations)

require 'pry'; binding.pry

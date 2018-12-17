require 'csv'

class StatTracker
attr_reader :games,
            :teams,
            :game_teams
  def initialize(games, teams, game_teams)
    @games = games
    @teams = teams
    @game_teams = game_teams
  end

  def self.from_csv_test(locations)
    games = CSV.readlines(locations[:games])[1, 100]
    teams = CSV.readlines(locations[:teams])[1, 100]
    game_teams = CSV.readlines(locations[:game_teams])[1, 100]
    StatTracker.new(games, teams, game_teams)
  end

  def self.from_csv(locations)
    games = CSV.readlines(locations[:games])
    teams = CSV.readlines(locations[:teams])
    game_teams = CSV.readlines(locations[:game_teams])
    StatTracker.new(games, teams, game_teams)
  end
end

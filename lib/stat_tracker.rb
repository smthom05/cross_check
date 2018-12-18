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

  def highest_total_score
    highest_score = 0
    games.each do |game|
      current_score = game[6].to_i + game[7].to_i
        if current_score > highest_score
          highest_score = current_score
        end
    end
    highest_score
  end

  def lowest_total_score
    lowest_score = 0
    games.each do |game|
      current_score = game[6].to_i + game[7].to_i
        if current_score < lowest_score
          lowest_score = current_score
        end
    end
    lowest_score
  end
end

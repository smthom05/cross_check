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
    games = CSV.readlines(locations[:games])[1..-1]
    teams = CSV.readlines(locations[:teams])[1..-1]
    game_teams = CSV.readlines(locations[:game_teams])[1..-1]
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

  def biggest_blowout
    blowout = 0
    games.each do |game|
      score_difference = (game[6]..game[7]).to_a.count - 1
        if score_difference > blowout
          blowout = score_difference
        end
    end
    blowout
  end

  def count_of_games_by_season
    seasons_hash = @games.group_by do |game|
      game[1]
    end

    seasons_hash.each do |season, value|
      seasons_hash[season] = value.count
    end
  end
end

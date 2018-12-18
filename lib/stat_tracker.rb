require 'csv'
require './lib/game'
require './lib/game_teams'
require './lib/team'

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
    all_games = CSV.readlines(locations[:games])[1, 100].map do |game|
      Game.new(game)
    end
    all_game_teams = CSV.readlines(locations[:game_teams])[1, 100].map do |game|
      GameTeams.new(game)
    end
    all_teams = CSV.readlines(locations[:teams])[1, 100].map do |team|
      Team.new(team)
    end
    StatTracker.new(all_games, all_teams, all_game_teams)
  end

  def self.from_csv(locations)
    all_games = CSV.readlines(locations[:games])[1, -1].map do |game|
      Game.new(game)
    end
    all_game_teams = CSV.readlines(locations[:game_teams])[1, -1].map do |game|
      GameTeams.new(game)
    end
    all_teams = CSV.readlines(locations[:teams])[1, -1].map do |team|
      Team.new(team)
    end
    StatTracker.new(all_games, all_teams, all_game_teams)
  end


  # method to find venue with most games played
  def most_popular_venue
    venues = []
    @games.each do |game|
      venues << game.venue
    end
    venues.max_by {|venue| venues.count(venue)}
  end

  # method to find venue with least games played
  def least_popular_venue
    venues = []
    @games.each do |game|
      venues << game.venue
    end
    venues.min_by {|venue| venues.count(venue)}
  end

  #method to find season with most games played
  def season_with_most_games
    seasons = []
    @games.each do |game|
      seasons << game.season
    end
    (seasons.max_by {|season| seasons.count(season)}).to_i
  end

  #method to find season with fewest games played
  def season_with_fewest_games
    seasons = []
    @games.each do |game|
      seasons << game.season
    end
    (seasons.min_by {|season| seasons.count(season)}).to_i
  end

  def highest_total_score
    highest_score = 0
    games.each do |game|
      current_score = game.away_goals + game.home_goals
        if current_score > highest_score
          highest_score = current_score
        end
    end
    highest_score
  end

  def lowest_total_score
    lowest_score = 0
    games.each do |game|
      current_score = game.away_goals + game.home_goals
        if current_score < lowest_score
          lowest_score = current_score
        end
    end
    lowest_score
  end

  def biggest_blowout
    blowout = 0
    games.each do |game|
      score_difference = (game.away_goals..game.home_goals).to_a.count - 1
        if score_difference > blowout
          blowout = score_difference
        end
    end
    blowout
  end

  def count_of_games_by_season
    seasons_hash = @games.group_by do |game|
      game.season
    end
    seasons_hash.each do |season, value|
      seasons_hash[season] = value.count
    end
  end

  def percentage_home_wins
    home_games = []
    home_wins = []
    @game_teams.each do |game|
      if game.hoa == "home"
        home_games << game
        if game.won == "TRUE"
          home_wins << game
        end
      end
    end
    (home_wins.count.to_f / home_games.count.to_f) * 100.0
  end

  def percentage_visitor_wins
    visitor_games = []
    visitor_wins = []
    @game_teams.each do |game|
      if game.hoa == "away"
        visitor_games << game
        if game.won == "TRUE"
          visitor_wins << game
        end
      end
    end
    (visitor_wins.count.to_f / visitor_games.count.to_f) * 100.0
  end

  def average_goals_per_game
    goals_per_game = []
    @games.each do |game|
      goals_per_game << (game.away_goals + game.home_goals)
    end
    goals_per_game.sum.to_f / goals_per_game.count.to_f
  end

  def average_goals_by_season
    goals_by_season = Hash.new([])
    @games.each do |game|
      goals_by_season[game.season] += [game.away_goals + game.home_goals]
    end
    goals_by_season.each do |season_id, goals|
      goals_by_season[season_id] = (goals.sum.to_f / goals.count.to_f)
    end
    goals_by_season
  end
end

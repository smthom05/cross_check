require 'csv'
require 'pry'

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

  # method to find venue with most games played
  def most_popular_venue
    venues = []
    @games.each do |game|
      venues << game[10]
    end
    venues.max_by {|venue| venues.count(venue)}
  end

  # method to find venue with least games played
  def least_popular_venue
    venues = []
    @games.each do |game|
      venues << game[10]
    end
    venues.min_by {|venue| venues.count(venue)}
  end

  #method to find season with most games played
  def season_with_most_games
    seasons = []
    @games.each do |game|
      seasons << game[1]
    end
    (seasons.max_by {|season| seasons.count(season)}).to_i
  end

  #method to find season with fewest games played
  def season_with_fewest_games
    seasons = []
    @games.each do |game|
      seasons << game[1]
    end
    season_l = (seasons.min_by {|season| seasons.count(season)}).to_i

    # seasons_hash = @games.group_by do |game|
    #   game[1]
    # end
    #   seasons_hash.each do |season, value|
    #     seasons_hash[season] = value.count
    # end
    # seasons_hash
  end

end

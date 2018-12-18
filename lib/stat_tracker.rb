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
    games = CSV.readlines(locations[:games])
    teams = CSV.readlines(locations[:teams])
    game_teams = CSV.readlines(locations[:game_teams])
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
end

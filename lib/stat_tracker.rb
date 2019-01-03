require 'csv'
require_relative './game'
require_relative './game_teams'
require_relative './team'
require_relative './modules/league_stats'

class StatTracker

  include LeagueStats

  attr_reader :games,
              :teams,
              :game_teams
  def initialize(games, teams, game_teams)
    @games = games
    @teams = teams
    @game_teams = game_teams
    collect_league_stats
    collect_season_stats
  end

  def self.from_csv(locations)
    all_games = CSV.readlines(locations[:games])[1..-1].map {|game| Game.new(game)}
    all_game_teams = CSV.readlines(locations[:game_teams])[1..-1].map {|game| GameTeams.new(game)}
    all_teams = CSV.readlines(locations[:teams])[1..-1].map {|team| Team.new(team)}
    StatTracker.new(all_games, all_teams, all_game_teams)
  end

  # returns highest sum of the winning and losing teams’ scores
  def highest_total_score
    total_game_scores = games.map { |game| game.home_goals + game.away_goals}
    total_game_scores.max
  end

  # returns lowest sum of the winning and losing teams' scores
  def lowest_total_score
    total_game_scores = games.map { |game| game.home_goals + game.away_goals}
    total_game_scores.min
  end

  # returns highest score difference
  def biggest_blowout
    score_difference = games.map { |game| (game.home_goals - game.away_goals).abs}
    score_difference.max
  end

  # returns venue with most games played
  def most_popular_venue
    venues = @games.map { |game| game.venue }
    venues.max_by { |venue| venues.count(venue) }
  end

  # returns venue with least games played
  def least_popular_venue
    venues = @games.map { |game| game.venue }
    venues.min_by { |venue| venues.count(venue) }
  end

  # returns percentage of games a home team has won
  def percentage_home_wins
    home_wins = @teams.map { |team| team.home_wins }.sum
    home_games = @teams.map { |team| team.home_games }.sum
    (home_wins.to_f / home_games.to_f).round(2)
  end

  # returns percentage of games an away team has won
  def percentage_visitor_wins
    visitor_wins = @teams.map { |team| team.away_wins }.sum
    visitor_games = @teams.map { |team| team.away_games }.sum
    (visitor_wins.to_f / visitor_games.to_f).round(2)
  end

  # returns season with most games played
  def season_with_most_games
    seasons = @games.map { |game| game.season }
    seasons.max_by { |season| seasons.count(season) }
  end

  # returns season with fewest games played
  def season_with_fewest_games
    seasons = @games.map { |game| game.season }
    seasons.min_by { |season| seasons.count(season) }
  end

  # returns a hash with season names as keys and counts of games as values
  def count_of_games_by_season
    games_by_season = @games.group_by { |game| game.season.to_s }
    games_by_season.each { |season, games| games_by_season[season] = games.count }
  end

  # returns average number of goals scored in a game across all seasons
  def average_goals_per_game
    total_goals = @teams.map {|team| team.total_goals_scored}.sum
    total_games = @teams.map {|team| team.home_games}.sum
    (total_goals.to_f / total_games.to_f).round(2)
  end

  # returns a hash with season names as keys and average goals that season as a value
  def average_goals_by_season
    goals_by_season = @games.group_by { |game| game.season.to_s }
    goals_by_season.each do |season, games|
      season_goals = games.map { |game| game.home_goals + game.away_goals }.sum
      goals_by_season[season] = (season_goals.to_f / games.count.to_f).round(2)
    end
  end

  # returns total number of teams
  def count_of_teams
    @teams.count
  end

  # returns team with highest average number of goals
  def best_offense
    @teams.max_by { |team| team.average_goals_scored }.team_name
  end

  # returns team with lowest average number of goals
  def worst_offense
    @teams.min_by { |team| team.average_goals_scored }.team_name
  end

  # returns team with lowest average goals allowed
  def best_defense
    @teams.min_by { |team| team.average_goals_allowed }.team_name
  end

  # returns team with highest average goals allowed
  def worst_defense
    @teams.max_by { |team| team.average_goals_allowed }.team_name
  end

  # returns team with highest average away goals
  def highest_scoring_visitor
    @teams.max_by { |team| team.average_away_goals }.team_name
  end

  # returns team with highest average home goals
  def highest_scoring_home_team
    @teams.max_by { |team| team.average_home_goals }.team_name
  end

  # returns team with lowest average away goals
  def lowest_scoring_visitor
    @teams.min_by { |team| team.average_away_goals }.team_name
  end

  # returns team with lowest average home goals
  def lowest_scoring_home_team
    @teams.min_by { |team| team.average_home_goals }.team_name
  end

  # returns team with highest win percentage
  def winningest_team
    @teams.max_by { |team| team.total_win_percentage }.team_name
  end

  # returns team with biggest difference between home and away win percentages
  def best_fans
    @teams.max_by { |team| team.home_minus_away_percentage }.team_name
  end

  # returns array with all teams with better away than home records
  def worst_fans
    teams_with_bad_fans = @teams.find_all { |team| team.home_minus_away_percentage.negative? }
    teams_with_bad_fans.map { |team| team.team_name }
  end

  # returns team with biggest decrease between preseason and regular season win percentage
  def biggest_bust(season)
    season = season.to_i
    @teams.min_by{ |team| team.preseason_to_regular_increase[season] }.team_name
  end

  # returns team with biggest increase between preseason and regular season win percentage
  def biggest_surprise(season)
    season = season.to_i
    @teams.max_by{ |team| team.preseason_to_regular_increase[season] }.team_name
  end

  # A hash with two keys (:preseason, and :regular_season) each pointing to a hash with the keys :win_percentage, :goals_scored, and :goals_against
  def season_summary(season, team_id)
    season = season.to_i
    team = ""
    @teams.each do |each_team|
      if each_team.team_id.to_s == team_id
        team = each_team
      end
    end
    preseason_win_percentage = (team.preseason_wins[season].to_f / team.preseason_games[season].to_f).round(2)
    regular_win_percentage = (team.regular_wins[season].to_f / team.regular_games[season].to_f).round(2)

    preseason_hash = {
      win_percentage: preseason_win_percentage,
      goals_scored: team.preseason_goals_scored[season],
      goals_against: team.preseason_goals_against[season]
    }
    regular_hash = {
      win_percentage: regular_win_percentage,
      goals_scored: team.regular_goals_scored[season],
      goals_against: team.regular_goals_against[season]
    }
    {
      preseason: preseason_hash,
      regular_season: regular_hash
    }
  end

  def average_win_percentage(team_id)
    team_id = team_id.to_i
    team = @teams.select { |each_team| each_team.team_id == team_id }.first
    games_played = team.away_games + team.home_games
    games_won = team.home_wins + team.away_wins
    (games_won.to_f / games_played.to_f).round(2)
  end

  def team_info(team_id)
    team_info_hash = {}
    @teams.each do |team|
      if team_id.to_i == team.team_id
        team_info_hash["team_id"] = team.team_id.to_s
        team_info_hash["franchise_id"] = team.franchise_id.to_s
        team_info_hash["short_name"] = team.short_name
        team_info_hash["team_name"] = team.team_name
        team_info_hash["abbreviation"] = team.abbreviation
        team_info_hash["link"] = team.link
      end
    end
    team_info_hash
  end

  def most_goals_scored(team_id)
    team_id = team_id.to_i
    goals_per_game = @game_teams.map do |game|
      if game.team_id == team_id
        game.goals
      end
    end
    goals_per_game.compact.max
  end

  def fewest_goals_scored(team_id)
    team_id = team_id.to_i
    goals_per_game = @game_teams.map do |game|
      if game.team_id == team_id
        game.goals
      end
    end
    goals_per_game.compact.min
  end

  def favorite_opponent(team_id)
    team_id = team_id.to_i
    team = @teams.select { |each_team| each_team.team_id == team_id }.first
    favorite_opponent_id = team.matchup_win_percentage.max_by{|each_team, percentage| percentage}.first
    @teams.select { |each_team| each_team.team_id == favorite_opponent_id }.first.team_name
  end

  def rival(team_id)
    team_id = team_id.to_i
    team = @teams.select { |each_team| each_team.team_id == team_id }.first
    rival_id = team.matchup_win_percentage.min_by{|each_team, percentage| percentage}.first
    @teams.select { |each_team| each_team.team_id == rival_id }.first.team_name
  end

  def biggest_team_blowout(team_id)
    @games.map do |game|
      if game.away_team_id.to_s == team_id
        game.away_goals - game.home_goals
      elsif game.home_team_id.to_s == team_id
        game.home_goals - game.away_goals
      end
    end.compact.max
  end

  def worst_loss(team_id)
    @games.map do |game|
      if game.away_team_id.to_s == team_id
        game.home_goals - game.away_goals
      elsif game.home_team_id.to_s == team_id
        game.away_goals - game.home_goals
      end
    end.compact.max
  end

  def seasonal_summary(team_id)
    team_id = team_id.to_i
    team = @teams.select { |each_team|  each_team.team_id == team_id }.first
    seasons_played = @games.map do |game|
      if game.home_team_id == team_id || game.away_team_id == team_id
        game.season
      end
    end.compact.uniq
    seasonal_summary = {}
    seasons_played.each do |season|
      seasonal_summary[season.to_s] = {
        preseason: {
          win_percentage: team.preseason_win_percentage[season].round(2),
          total_goals_scored: team.preseason_goals_scored[season],
          total_goals_against: team.preseason_goals_against[season],
          average_goals_scored: team.preseason_average_goals_scored[season].round(2),
          average_goals_against: team.preseason_average_goals_against[season].round(2)
        },
        regular_season: {
          win_percentage: team.regular_win_percentage[season].round(2),
          total_goals_scored: team.regular_goals_scored[season],
          total_goals_against: team.regular_goals_against[season],
          average_goals_scored: team.regular_average_goals_scored[season].round(2),
          average_goals_against: team.regular_average_goals_against[season].round(2)
        }
      }
    end
    seasonal_summary
  end

  def head_to_head(team_id)
    team_id = team_id.to_i
    head_to_head_hash = {}
    team = @teams.select { |each_team| each_team.team_id == team_id }.first
    head_to_head_id_hash = team.matchup_win_percentage
    head_to_head_id_hash.each do |team_id, win_percentage|
      @teams.each do |team|
        if team.team_id == team_id
          head_to_head_hash[team.team_name] = win_percentage
        end
      end
    end
    head_to_head_hash
  end

  def best_season(team_id)
    team_id = team_id.to_i
    team_seasonal_summary = seasonal_summary(team_id)
      best_season = seasonal_summary(team_id).keys.first
      team_seasonal_summary.each do |season, stats|
        if stats[:regular_season][:win_percentage] > team_seasonal_summary[best_season][:regular_season][:win_percentage]
          best_season = season
        end
      end
    best_season.to_s
  end

  def worst_season(team_id)
    team_id = team_id.to_i
    team_seasonal_summary = seasonal_summary(team_id)
    worst_season = seasonal_summary(team_id).keys.first
    team_seasonal_summary.each do |season, stats|
      if stats[:regular_season][:win_percentage] < team_seasonal_summary[worst_season][:regular_season][:win_percentage]
        worst_season = season
      end
    end
    worst_season.to_s
  end
end

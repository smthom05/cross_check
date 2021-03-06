require 'csv'
require_relative './game'
require_relative './game_teams'
require_relative './team'
require_relative './modules/league_stats'
require_relative './modules/templates'

class StatTracker

  include LeagueStats
  include Templates

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
    venues = @games.group_by { |game| game.venue}
    venues.max_by { |venue, games| games.count }.first
  end

  # returns venue with least games played
  def least_popular_venue
    venues = @games.group_by { |game| game.venue}
    venues.min_by { |venue, games| games.count }.first
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
    seasons = @games.group_by { |game| game.season }
    seasons.max_by { |season, games| games.count }.first
  end

  # returns season with fewest games played
  def season_with_fewest_games
    seasons = @games.group_by { |game| game.season }
    seasons.min_by { |season, games| games.count }.first
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
    team_id = team_id.to_i
    season_summary_hash(season, team_id)
  end

  # returns a hash with key/value pairs for each of the attributes of a team
  def team_info(team_id)
    team_info_hash(team_id)
  end

  # returns the season with the highest win percentage for a team
  def best_season(team_id)
    team_id = team_id.to_i
    team = @teams.select { |each_team| each_team.team_id == team_id }.first
    team.season_win_percentages.max_by { |season, percentage| percentage }.first.to_s
  end

  # returns the season with the lowest win percentage for a team
  def worst_season(team_id)
    team_id = team_id.to_i
    team = @teams.select { |each_team| each_team.team_id == team_id }.first
    team.season_win_percentages.min_by { |season, percentage| percentage }.first.to_s
  end

  # returns average win percentage of all games for a team
  def average_win_percentage(team_id)
    team_id = team_id.to_i
    team = @teams.select { |each_team| each_team.team_id == team_id }.first
    team.total_win_percentage.round(2)
  end

  # returns the highest number of goals a particular team has scored in a game
  def most_goals_scored(team_id)
    team_id = team_id.to_i
    goals_per_game = @game_teams.map do |game|
      if game.team_id == team_id
        game.goals
      end
    end
    goals_per_game.compact.max
  end

  # returns the lowest number of goals a particular team has scored in a game
  def fewest_goals_scored(team_id)
    team_id = team_id.to_i
    goals_per_game = @game_teams.map do |game|
      if game.team_id == team_id
        game.goals
      end
    end
    goals_per_game.compact.min
  end

  # returns the name of the opponent that has the lowest win percentage against the given team
  def favorite_opponent(team_id)
    team_id = team_id.to_i
    team = @teams.select { |each_team| each_team.team_id == team_id }.first
    favorite_opponent_id = team.matchup_win_percentage.max_by{|each_team, percentage| percentage}.first
    @teams.select { |each_team| each_team.team_id == favorite_opponent_id }.first.team_name
  end

  # returns the name of the opponent that has the highest win percentage against the given team
  def rival(team_id)
    team_id = team_id.to_i
    team = @teams.select { |each_team| each_team.team_id == team_id }.first
    rival_id = team.matchup_win_percentage.min_by{|each_team, percentage| percentage}.first
    @teams.select { |each_team| each_team.team_id == rival_id }.first.team_name
  end

  # returns the biggest difference between team goals and opponent goals for a win for the given team
  def biggest_team_blowout(team_id)
    @games.map do |game|
      if game.away_team_id.to_s == team_id
        game.away_goals - game.home_goals
      elsif game.home_team_id.to_s == team_id
        game.home_goals - game.away_goals
      end
    end.compact.max
  end

  # returns the biggest difference between team goals and opponent goals for a loss for the given team
  def worst_loss(team_id)
    @games.map do |game|
      if game.away_team_id.to_s == team_id
        game.home_goals - game.away_goals
      elsif game.home_team_id.to_s == team_id
        game.away_goals - game.home_goals
      end
    end.compact.max
  end

  # For each season a team has played, returns a hash that has two keys (:preseason, and :regular_season), that each point to a hash with the following keys: :win_percentage, :total_goals_scored, :total_goals_against, :average_goals_scored, :average_goals_against
  def seasonal_summary(team_id)
    team_id = team_id.to_i
    seasonal_summary_hash(team_id)
  end

  # returns record (as a hash - win/loss) against each opponent
  def head_to_head(team_id)
    team_id = team_id.to_i
    head_to_head_hash = {}
    team = @teams.select { |each_team| each_team.team_id == team_id }.first
    head_to_head_id_hash = team.matchup_win_percentage
    head_to_head_id_hash.each do |each_team_id, win_percentage|
      @teams.each do |each_team|
        if each_team.team_id == each_team_id
          head_to_head_hash[each_team.team_name] = win_percentage
        end
      end
    end
    head_to_head_hash
  end
end

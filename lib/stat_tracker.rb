require 'csv'
require './lib/game'
require './lib/game_teams'
require './lib/team'
require './lib/modules/league_stats'
require './lib/modules/seasons_calculations'

class StatTracker

  include LeagueStats
  include SeasonsCalculations

  attr_reader :games,
              :teams,
              :game_teams
  def initialize(games, teams, game_teams)
    @games = games
    @teams = teams
    @game_teams = game_teams
    collect_league_stats
  end

  def self.from_csv(locations)
    all_games = CSV.readlines(locations[:games])[1..-1].map do |game|
      Game.new(game)
    end
    all_game_teams = CSV.readlines(locations[:game_teams])[1..-1].map do |game|
      GameTeams.new(game)
    end
    all_teams = CSV.readlines(locations[:teams])[1..-1].map do |team|
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
    (seasons.max_by {|season| seasons.count(season)})
  end

  #method to find season with fewest games played
  def season_with_fewest_games
    seasons = []
    @games.each do |game|
      seasons << game.season
    end
    (seasons.min_by {|season| seasons.count(season)})
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
    home_wins = @teams.map {|team| team.home_wins}.sum
    home_games = @teams.map {|team| team.home_games}.sum
    (home_wins.to_f / home_games.to_f * 100.00).round(2)
  end

  def percentage_visitor_wins
    visitor_wins = @teams.map {|team| team.away_wins}.sum
    visitor_games = @teams.map {|team| team.away_games}.sum
    (visitor_wins.to_f / visitor_games.to_f * 100.0).round(2)
  end

  def average_goals_per_game
    total_goals = @teams.map {|team| team.total_goals_scored}.sum
    total_games = @teams.map {|team| team.home_games}.sum
    (total_goals.to_f / total_games.to_f).round(2)
  end

  def average_goals_by_season
    goals_by_season = Hash.new([])
    @games.each do |game|
      goals_by_season[game.season] += [game.away_goals + game.home_goals]
    end
    goals_by_season.each do |season_id, goals|
      goals_by_season[season_id] = (goals.sum.to_f / goals.count.to_f).round(2)
    end
    goals_by_season
  end

  def highest_scoring_home_team
    average_home_scores = @teams.map {|team| team.home_goals_scored.to_f / team.home_games.to_f}
    index = average_home_scores.each_with_index.max[1]
    @teams[index].team_name
  end

  def lowest_scoring_home_team
    average_home_scores = @teams.map {|team| team.home_goals_scored.to_f / team.home_games.to_f}
    index = average_home_scores.each_with_index.min[1]
    @teams[index].team_name
  end

  def highest_scoring_visitor
    average_away_scores = @teams.map {|team| team.away_goals_scored.to_f / team.away_games.to_f}
    index = average_away_scores.each_with_index.max[1]
    @teams[index].team_name
  end

  def lowest_scoring_visitor
    average_away_scores = @teams.map {|team| team.away_goals_scored.to_f / team.away_games.to_f}
    index = average_away_scores.each_with_index.min[1]
    @teams[index].team_name
  end

  def best_offense
    goals_scored = @teams.map {|team| team.total_goals_scored}
    games_played = @teams.map {|team| team.total_games}
    goals_and_games = goals_scored.zip(games_played)
    average_goals = goals_and_games.map {|pair| pair[0].to_f / pair[1].to_f}
    index = average_goals.each_with_index.max[1]
    @teams[index].team_name
  end
  #
  def worst_offense
    goals_scored = @teams.map {|team| team.total_goals_scored}
    games_played = @teams.map {|team| team.total_games}
    goals_and_games = goals_scored.zip(games_played)
    average_goals = goals_and_games.map {|pair| pair[0].to_f / pair[1].to_f}
    index = average_goals.each_with_index.min[1]
    @teams[index].team_name
  end

  def best_defense
    goals_allowed = @teams.map {|team| team.total_goals_allowed}
    games_played = @teams.map {|team| team.total_games}
    goals_allowed_and_games = goals_allowed.zip(games_played)
    average_goals_allowed = goals_allowed_and_games.map {|pair| pair[0].to_f / pair[1].to_f}
    index = average_goals_allowed.each_with_index.min[1]
    @teams[index].team_name
  end

  def worst_defense
    goals_allowed = @teams.map {|team| team.total_goals_allowed}
    games_played = @teams.map {|team| team.total_games}
    goals_allowed_and_games = goals_allowed.zip(games_played)
    average_goals_allowed = goals_allowed_and_games.map {|pair| pair[0].to_f / pair[1].to_f}
    index = average_goals_allowed.each_with_index.max[1]
    @teams[index].team_name
  end

  def count_of_teams
    @teams.count
  end

  def winningest_team
    number_of_wins = @teams.map {|team| team.total_wins}
    games_played = @teams.map {|team| team.total_games}
    wins_and_games = number_of_wins.zip(games_played)
    win_percentage = wins_and_games.map {|pair| pair[0].to_f / pair[1].to_f}
    index = win_percentage.each_with_index.max[1]
    @teams[index].team_name
  end

  def best_fans
    home_wins = @teams.map {|team| team.home_wins}
    home_games = @teams.map {|team| team.home_games}
    away_wins = @teams.map {|team| team.away_wins}
    away_games = @teams.map {|team| team.away_games}
    home_wins_and_games = home_wins.zip(home_games)
    away_wins_and_games = away_wins.zip(away_games)
    home_win_percentage = home_wins_and_games.map {|pair| pair[0].to_f / pair[1].to_f}
    away_win_percentage = away_wins_and_games.map {|pair| pair[0].to_f / pair[1].to_f}
    home_and_away_win_percentage = home_win_percentage.zip(away_win_percentage)
    win_percentage_difference = home_and_away_win_percentage.map {|pair| pair[0].to_f - pair[1].to_f}
    index = win_percentage_difference.each_with_index.max[1]
    @teams[index].team_name
  end

  def worst_fans
    home_wins = @teams.map {|team| team.home_wins}
    home_games = @teams.map {|team| team.home_games}
    away_wins = @teams.map {|team| team.away_wins}
    away_games = @teams.map {|team| team.away_games}
    home_wins_and_games = home_wins.zip(home_games)
    away_wins_and_games = away_wins.zip(away_games)
    home_win_percentage = home_wins_and_games.map {|pair| pair[0].to_f / pair[1].to_f}
    away_win_percentage = away_wins_and_games.map {|pair| pair[0].to_f / pair[1].to_f}
    away_and_home_win_percentage = away_win_percentage.zip(home_win_percentage)
    win_percentage_difference = away_and_home_win_percentage.map {|pair| pair[0].to_f - pair[1].to_f}
    indexes_of_teams_with_bad_fans = []
    win_percentage_difference.each_with_index do |percentage, index|
      if percentage > 0
        indexes_of_teams_with_bad_fans << index
      end
    end
    indexes_of_teams_with_bad_fans.map {|index| @teams[index].team_name}
  end

  def biggest_bust(season)
    collect_season_stats(season)
    preseason_games = teams.map {|team| team.preseason_games}
    preseason_wins = teams.map {|team| team.preseason_wins}
    regular_games = teams.map {|team| team.regular_games}
    regular_wins = teams.map {|team|team.regular_wins}
    preseason_wins_and_games = preseason_wins.zip(preseason_games)
    regular_wins_and_games = regular_wins.zip(regular_games)
    preseason_win_percentage = preseason_wins_and_games.map do |pair|
      if pair[1] == 0
        0
      else
        pair[0].to_f / pair[1].to_f
      end
    end
    regular_win_percentage = regular_wins_and_games.map do |pair|
      if pair[1] == 0
        0
      else
        pair[0].to_f / pair[1].to_f
      end
    end
    preseason_and_regular_win_percentage = preseason_win_percentage.zip(regular_win_percentage)
    biggest_bust = preseason_and_regular_win_percentage.map {|pair| pair[0] - pair[1]}
    biggest_bust_index = biggest_bust.each_with_index.max[1]
    @teams[biggest_bust_index].team_name
  end


  def average_win_percentage(team_id)
    games_played = 0
    games_won = 0

    game_teams.each do |game|
      if game.team_id == team_id && game.won? == true
        games_played += 1.0
        games_won += 1.0
      elsif game.team_id == team_id && game.won? == false
        games_played += 1.0
      end
    end
    games_won / games_played
  end

  def biggest_surprise(season)
    collect_season_stats(season)
    preseason_games = teams.map {|team| team.preseason_games}
    preseason_wins = teams.map {|team| team.preseason_wins}
    regular_games = teams.map {|team| team.regular_games}
    regular_wins = teams.map {|team|team.regular_wins}
    preseason_wins_and_games = preseason_wins.zip(preseason_games)
    regular_wins_and_games = regular_wins.zip(regular_games)
    preseason_win_percentage = preseason_wins_and_games.map do |pair|
      if pair[1] == 0
        0
      else
        pair[0].to_f / pair[1].to_f
      end
    end
    regular_win_percentage = regular_wins_and_games.map do |pair|
      if pair[1] == 0
        0
      else
        pair[0].to_f / pair[1].to_f
      end
    end
    regular_and_preseason_win_percentage = regular_win_percentage.zip(preseason_win_percentage)
    biggest_surprise = regular_and_preseason_win_percentage.map {|pair| pair[0] - pair[1]}
    biggest_surprise_index = biggest_surprise.each_with_index.max[1]
    @teams[biggest_surprise_index].team_name
  end

  def team_info(team_id)
    team_info_hash = {}
    @teams.each do |team|
      if team_id == team.team_id
        team_info_hash[:team_id] = team.team_id
        team_info_hash[:franchise_id] = team.franchise_id
        team_info_hash[:short_name] = team.short_name
        team_info_hash[:team_name] = team.team_name
        team_info_hash[:abbreviation] = team.abbreviation
        team_info_hash[:link] = team.link
      end
    end
    team_info_hash
  end

  def season_summary(season, team_id)
    collect_season_stats(season)
    team = ""
    @teams.each do |each_team|
      if each_team.team_id == team_id
        team = each_team
      end
    end

    preseason_win_percentage = team.preseason_wins.to_f / team.preseason_games.to_f * 100.0
    regular_win_percentage = team.regular_wins.to_f / team.regular_games.to_f * 100.0

    preseason_hash = {
      win_percentage: preseason_win_percentage,
      goals_scored: team.preseason_goals_scored,
      goals_against: team.preseason_goals_against
    }
    regular_hash = {
      win_percentage: regular_win_percentage,
      goals_scored: team.regular_goals_scored,
      goals_against: team.regular_goals_against
    }
    {
      preseason: preseason_hash,
      regular_season: regular_hash
    }
  end
#
  def most_goals_scored(team_id)
    goals_per_game = @game_teams.map do |game|
      if game.team_id == team_id
        game.goals
      end
    end
    goals_per_game.compact.max
  end

  def least_goals_scored(team_id)
    goals_per_game = @game_teams.map do |game|
      if game.team_id == team_id
        game.goals
      end
    end
    goals_per_game.compact.min
  end

  def favorite_opponent(team_id)
    teams_played_by_id = @games.map do |game|
      if game.away_team_id == team_id
        game.home_team_id
      elsif game.home_team_id == team_id
        game.away_team_id
      end
    end.compact.uniq
    teams_and_wins = Hash.new(0)
    teams_and_games = Hash.new(0)
    @games.each do |game|
      teams_played_by_id.each do |team|
        if game.away_team_id == team
          teams_and_games[team] += 1
          if game.away_goals > game.home_goals
            teams_and_wins[team] += 1
          end
        elsif game.home_team_id == team
          teams_and_games[team] += 1
          if game.home_goals > game.away_goals
            teams_and_wins[team] += 1
          end
        end
      end
    end
    require "pry"; binding.pry
    # Combine and values of hashes
    # Divide wins by games
    # Select team id with lowest win percentage
    # Return team with matching team id
  end

  def rival(team_id)
  end

  def biggest_team_blowout(team_id)
    @games.map do |game|
      if game.away_team_id == team_id
        game.away_goals - game.home_goals
      elsif game.home_team_id == team_id
        game.home_goals - game.away_goals
      end
    end.compact.max
  end

  def worst_loss(team_id)
    @games.map do |game|
      if game.away_team_id == team_id
        game.home_goals - game.away_goals
      elsif game.home_team_id == team_id
        game.away_goals - game.home_goals
      end
    end.compact.max
  end

  def seasonal_summary(team_id)
    team = @teams.select do |team|
      team.team_id == team_id
    end[0]
    seasons_played = @games.map do |game|
      if game.home_team_id == team_id || game.away_team_id == team_id
        game.season
      end
    end.compact.uniq
    seasonal_summary = {}
    seasons_played.each do |season|
      collect_season_stats(season)
      seasonal_summary[season] = {
        preseason: {
          win_percentage: team.preseason_win_percentage,
          total_goals_scored: team.preseason_goals_scored,
          total_goals_against: team.preseason_goals_against,
          average_goals_scored: team.preseason_average_goals_scored,
          average_goals_against: team.preseason_average_goals_against
        },
        regular_season: {
          win_percentage: team.regular_win_percentage,
          total_goals_scored: team.regular_goals_scored,
          total_goals_against: team.regular_goals_against,
          average_goals_scored: team.regular_average_goals_scored,
          average_goals_against: team.regular_average_goals_against
        }
      }
    end
    seasonal_summary
  end
end

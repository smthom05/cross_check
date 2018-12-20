require 'csv'
require './lib/game'
require './lib/game_teams'
require './lib/team'
require './lib/score_finder'

class StatTracker

  include ScoreFinder

  attr_reader :games,
              :teams,
              :game_teams
  def initialize(games, teams, game_teams)
    @games = games
    @teams = teams
    @game_teams = game_teams
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

  def highest_scoring_home_team
    team_scores_by_id = generate_scores_by_team_id(teams)
    team_games_by_id = generate_number_of_games_by_team_id(game_teams)
    goals_at_home = add_goals_by_home_or_away("home", team_scores_by_id)
    average_hash = average_goals_per_game_by_team(goals_at_home, team_games_by_id)
    highest_scoring_home_team = highest_scoring_team(average_hash)
  end

  def lowest_scoring_home_team
    team_games_by_id = generate_number_of_games_by_team_id(game_teams)
    team_scores_by_id = generate_scores_by_team_id(teams)
    goals_at_home = add_goals_by_home_or_away("home", team_scores_by_id)
    average_hash = average_goals_per_game_by_team(goals_at_home, team_games_by_id)
    lowest_scoring_home_team = lowest_scoring_team(average_hash)
  end

  def highest_scoring_visitor
    team_games_by_id = generate_number_of_games_by_team_id(game_teams)
    team_scores_by_id = generate_scores_by_team_id(teams)
    goals_away = add_goals_by_home_or_away("away", team_scores_by_id)
    average_hash = average_goals_per_game_by_team(goals_away, team_games_by_id)
    highest_scoring_visitor = highest_scoring_team(average_hash)
  end

  def lowest_scoring_visitor
    team_games_by_id = generate_number_of_games_by_team_id(game_teams)
    team_scores_by_id = generate_scores_by_team_id(teams)
    goals_away = add_goals_by_home_or_away("away", team_scores_by_id)
    average_hash = average_goals_per_game_by_team(goals_away, team_games_by_id)
    lowest_scoring_visitor = lowest_scoring_team(average_hash)
  end


  def best_offense
    teams_games = Hash[@teams.map {|team| [team, 0]}]
    teams_goals = Hash[@teams.map {|team| [team, 0]}]

    @game_teams.each do |game|
      @teams.each do |team|
        if team.team_id == game.team_id
          teams_games[team] += 1
          teams_goals[team] += game.goals.to_f
        end
      end
    end

    teams_avg_goals = teams_goals.merge(teams_games){|key, old, new| Array(old).push(new) }
    teams_avg_goals.each do |a, b|
      if b[1] != 0
        teams_avg_goals[a] = b[0].to_f / b[1].to_f
      else
        teams_avg_goals[a] = 0
      end
    end
    best_offensive_team = teams_avg_goals.max_by do |team, gpg|
      gpg
    end
    best_offensive_team[0].team_name
  end

  def worst_offense
    teams_games = Hash[@teams.map {|team| [team, 0]}]
    teams_goals = Hash[@teams.map {|team| [team, 0]}]

    @game_teams.each do |game|
      @teams.each do |team|
        if team.team_id == game.team_id
          teams_games[team] += 1
          teams_goals[team] += game.goals.to_f
        end
      end
    end

    teams_avg_goals = teams_goals.merge(teams_games){|key, old, new| Array(old).push(new) }
    teams_avg_goals.each do |a, b|
      if b[1] != 0
        teams_avg_goals[a] = b[0].to_f / b[1].to_f
      else
        teams_avg_goals[a] = 0
      end
    end

    worst_offensive_team = teams_avg_goals.min_by do |team, gpg|
      gpg
    end
    worst_offensive_team[0].team_name
  end

  def best_defense
    teams_games = Hash[@teams.map {|team| [team, 0]}]
    teams_goals_against = Hash[@teams.map {|team| [team, 0]}]

    @game_teams.each do |game|
      @teams.each do |team|
        if team.team_id == game.team_id
          teams_games[team] += 1
        end
      end
    end

    @games.each do |game|
      @teams.each do |team|
        if game.away_team_id == team.team_id
          teams_goals_against[team] += game.home_goals
        elsif game.home_team_id == team.team_id
          teams_goals_against[team] += game.away_goals
        end
      end
    end
    teams_avg_goals_against = teams_goals_against.merge(teams_games){|key, old, new| Array(old).push(new) }
    teams_avg_goals_against.each do |a, b|
      if b[1] != 0
        teams_avg_goals_against[a] = b[0].to_f / b[1].to_f
      else
        teams_avg_goals_against[a] = 0
      end
    end
    best_defensive_team = teams_avg_goals_against.min_by do |team, gpg_against|
      gpg_against
    end
    best_defensive_team[0].team_name
  end

  def worst_defense
    teams_games = Hash[@teams.map {|team| [team, 0]}]
    teams_goals_against = Hash[@teams.map {|team| [team, 0]}]

    @game_teams.each do |game|
      @teams.each do |team|
        if team.team_id == game.team_id
          teams_games[team] += 1
        end
      end
    end

    @games.each do |game|
      @teams.each do |team|
        if game.away_team_id == team.team_id
          teams_goals_against[team] += game.home_goals
        elsif game.home_team_id == team.team_id
          teams_goals_against[team] += game.away_goals
        end
      end
    end
    teams_avg_goals_against = teams_goals_against.merge(teams_games){|key, old, new| Array(old).push(new) }
    teams_avg_goals_against.each do |a, b|
      if b[1] != 0
        teams_avg_goals_against[a] = b[0].to_f / b[1].to_f
      else
        teams_avg_goals_against[a] = 0
      end
    end
    worst_defensive_team = teams_avg_goals_against.max_by do |team, gpg_against|
      gpg_against
    end
    worst_defensive_team[0].team_name
  end

  def count_of_teams
    @teams.count
  end


  def winningest_team
    teams_and_number_of_wins = Hash[@teams.map {|team| [team, 0]}]
    teams_and_total_games = Hash[@teams.map {|team| [team, 0]}]
    @game_teams.each do |game|
      @teams.each do |team|
        if team.team_id == game.team_id
          teams_and_total_games[team] += 1
          if game.won == "TRUE"
            teams_and_number_of_wins[team] += 1
          end
        end
      end
    end
    wins_and_games = teams_and_number_of_wins.merge(teams_and_total_games){|key, old, new| Array(old).push(new) }
    wins_and_games.each do |team, pair|
      if pair[1] != 0
        wins_and_games[team] = (pair[0].to_f / pair[1].to_f)
      else wins_and_games[team] = 0
      end
    end
    wins_and_games.max_by{|team, win_percentage| win_percentage}[0].team_name
  end

  def best_fans
    teams_and_total_home_games = Hash[@teams.map {|team| [team, 0]}]
    teams_and_total_away_games = Hash[@teams.map {|team| [team, 0]}]
    teams_and_home_wins = Hash[@teams.map {|team| [team, 0]}]
    teams_and_away_wins = Hash[@teams.map {|team| [team, 0]}]
    @game_teams.each do |game|
      @teams.each do |team|
        if team.team_id == game.team_id && game.hoa == "away"
          teams_and_total_away_games[team] += 1
          if game.won == "TRUE"
            teams_and_away_wins[team] += 1
          end
        elsif team.team_id == game.team_id && game.hoa == "home"
          teams_and_total_home_games[team] += 1
            if game.won == "TRUE"
              teams_and_home_wins[team] += 1
            end
        end
      end
    end
    home_wins_and_games = teams_and_home_wins.merge(teams_and_total_home_games){|key, old, new| Array(old).push(new)}
    away_wins_and_games = teams_and_away_wins.merge(teams_and_total_away_games){|key, old, new| Array(old).push(new)}
    home_wins_and_games.each do |team, pair|
      if pair[1] != 0
        home_wins_and_games[team] = (pair[0].to_f / pair[1].to_f)
      else home_wins_and_games[team] = 0
      end
    end
    away_wins_and_games.each do |team, pair|
      if pair[1] != 0
        away_wins_and_games[team] = (pair[0].to_f / pair[1].to_f)
      else away_wins_and_games[team] = 0
      end
    end
    home_and_away_win_percentage = home_wins_and_games.merge(away_wins_and_games){|key, old, new| Array(old).push(new)}
    home_and_away_win_percentage.each do |team, pair|
      home_and_away_win_percentage[team] = (pair[0] - pair[1])
    end
    home_and_away_win_percentage.max_by{|team, win_percentage| win_percentage}[0].team_name
  end

  def worst_fans
    teams_and_total_home_games = Hash[@teams.map {|team| [team, 0]}]
    teams_and_total_away_games = Hash[@teams.map {|team| [team, 0]}]
    teams_and_home_wins = Hash[@teams.map {|team| [team, 0]}]
    teams_and_away_wins = Hash[@teams.map {|team| [team, 0]}]
    @game_teams.each do |game|
      @teams.each do |team|
        if team.team_id == game.team_id && game.hoa == "away"
          teams_and_total_away_games[team] += 1
          if game.won == "TRUE"
            teams_and_away_wins[team] += 1
          end
        elsif team.team_id == game.team_id && game.hoa == "home"
          teams_and_total_home_games[team] += 1
            if game.won == "TRUE"
              teams_and_home_wins[team] += 1
            end
        end
      end
    end
    home_wins_and_games = teams_and_home_wins.merge(teams_and_total_home_games){|key, old, new| Array(old).push(new)}
    away_wins_and_games = teams_and_away_wins.merge(teams_and_total_away_games){|key, old, new| Array(old).push(new)}
    home_wins_and_games.each do |team, pair|
      if pair[1] != 0
        home_wins_and_games[team] = (pair[0].to_f / pair[1].to_f)
      else home_wins_and_games[team] = 0
      end
    end
    away_wins_and_games.each do |team, pair|
      if pair[1] != 0
        away_wins_and_games[team] = (pair[0].to_f / pair[1].to_f)
      else away_wins_and_games[team] = 0
      end
    end
    away_and_home_win_percentage = away_wins_and_games.merge(home_wins_and_games){|key, old, new| Array(old).push(new)}
    away_and_home_win_percentage.each do |team, pair|
      away_and_home_win_percentage[team] = (pair[0] - pair[1])
    end
    worst_fans = away_and_home_win_percentage.select do |team, percentage|
      percentage > 0
    end

    worst_fans.keys
  end

  def biggest_bust(season)
    teams_and_preseason_games = Hash[@teams.map {|team| [team, 0]}]
    teams_and_regular_games = Hash[@teams.map {|team| [team, 0]}]
    teams_and_preseason_wins = Hash[@teams.map {|team| [team, 0]}]
    teams_and_regular_wins = Hash[@teams.map {|team| [team, 0]}]
    preseason_games = []
    regular_games = []
    @games.each do |game|
      if game.season == season && game.type == "P"
        preseason_games << game
      elsif game.season == season && game.type == "R"
        regular_games << game
      end
    end
    preseason_game_ids = preseason_games.map do |game|
      game.game_id
    end
    regular_game_ids = regular_games.map do |game|
      game.game_id
    end

    preseason_game_teams = []
    @game_teams.each do |game|
      if preseason_game_ids.include?(game.game_id)
        preseason_game_teams << game
      end
    end
    regular_game_teams = []
    @game_teams.each do |game|
      if regular_game_ids.include?(game.game_id)
        regular_game_teams << game
      end
    end
    preseason_game_teams.each do |game|
      @teams.each do |team|
        if team.team_id == game.team_id
          teams_and_preseason_games[team] += 1
          if game.won == "TRUE"
            teams_and_preseason_wins[team] += 1
          end
        end
      end
    end
    regular_game_teams.each do |game|
      @teams.each do |team|
        if team.team_id == game.team_id
          teams_and_regular_games[team] += 1
          if game.won == "TRUE"
            teams_and_regular_wins[team] += 1
          end
        end
      end
    end
    preseason_win_percentage = teams_and_preseason_wins.merge(teams_and_preseason_games){|key, old, new| Array(old).push(new)}
    regular_win_percentage = teams_and_regular_wins.merge(teams_and_regular_games){|key, old, new| Array(old).push(new)}
    preseason_win_percentage.each do |team, pair|
      if pair[1] != 0
        preseason_win_percentage[team] = (pair[0].to_f / pair[1].to_f)
      else preseason_win_percentage[team] = 0
      end
    end
    regular_win_percentage.each do |team, pair|
      if pair[1] != 0
        regular_win_percentage[team] = (pair[0].to_f / pair[1].to_f)
      else regular_win_percentage[team] = 0
      end
    end
    biggest_bust = regular_win_percentage.merge(preseason_win_percentage){|key, old, new| Array(old).push(new)}
    biggest_bust.each do |team, pair|
      if pair[1] != 0 && pair[0] != 0
        biggest_bust[team] = (pair[0].to_f - pair[1].to_f)
      else biggest_bust[team] = 0
      end
    end
    biggest_bust.max_by{|team, win_percentage_difference| win_percentage_difference}[0].team_name
  end

  def biggest_surprise(season)
    teams_and_preseason_games = Hash[@teams.map {|team| [team, 0]}]
    teams_and_regular_games = Hash[@teams.map {|team| [team, 0]}]
    teams_and_preseason_wins = Hash[@teams.map {|team| [team, 0]}]
    teams_and_regular_wins = Hash[@teams.map {|team| [team, 0]}]
    preseason_games = []
    regular_games = []
    @games.each do |game|
      if game.season == season && game.type == "P"
        preseason_games << game
      elsif game.season == season && game.type == "R"
        regular_games << game
      end
    end
    preseason_game_ids = preseason_games.map do |game|
      game.game_id
    end
    regular_game_ids = regular_games.map do |game|
      game.game_id
    end

    preseason_game_teams = []
    @game_teams.each do |game|
      if preseason_game_ids.include?(game.game_id)
        preseason_game_teams << game
      end
    end
    regular_game_teams = []
    @game_teams.each do |game|
      if regular_game_ids.include?(game.game_id)
        regular_game_teams << game
      end
    end
    preseason_game_teams.each do |game|
      @teams.each do |team|
        if team.team_id == game.team_id
          teams_and_preseason_games[team] += 1
          if game.won == "TRUE"
            teams_and_preseason_wins[team] += 1
          end
        end
      end
    end
    regular_game_teams.each do |game|
      @teams.each do |team|
        if team.team_id == game.team_id
          teams_and_regular_games[team] += 1
          if game.won == "TRUE"
            teams_and_regular_wins[team] += 1
          end
        end
      end
    end
    preseason_win_percentage = teams_and_preseason_wins.merge(teams_and_preseason_games){|key, old, new| Array(old).push(new)}
    regular_win_percentage = teams_and_regular_wins.merge(teams_and_regular_games){|key, old, new| Array(old).push(new)}
    preseason_win_percentage.each do |team, pair|
      if pair[1] != 0
        preseason_win_percentage[team] = (pair[0].to_f / pair[1].to_f)
      else preseason_win_percentage[team] = 0
      end
    end
    regular_win_percentage.each do |team, pair|
      if pair[1] != 0
        regular_win_percentage[team] = (pair[0].to_f / pair[1].to_f)
      else regular_win_percentage[team] = 0
      end
    end
    biggest_surprise = regular_win_percentage.merge(preseason_win_percentage){|key, old, new| Array(old).push(new)}
    biggest_surprise.each do |team, pair|
      if pair[1] != 0 && pair[0] != 0
        biggest_surprise[team] = (pair[1].to_f - pair[0].to_f)
      else biggest_surprise[team] = 0
      end
    end
    biggest_surprise.max_by{|team, win_percentage_difference| win_percentage_difference}[0].team_name
  end
end

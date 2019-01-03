module LeagueStats

  def collect_league_stats
    @games.each do |game|
      @teams.each do |team|
        if game.home_team_id == team.team_id
          home_team_stat_collector(team, game)
        elsif game.away_team_id == team.team_id
          away_team_stat_collector(team, game)
        end
      end
    end
  end

  def collect_season_stats
    @games.each do |game|
      @teams.each do |team|
        if game.home_team_id == team.team_id
          if game.type == "P"
            preseason_home_stat_collector(team, game)
          elsif game.type == "R"
            regular_home_stat_collector(team, game)
          end
        elsif game.away_team_id == team.team_id
          if game.type == "P"
            preseason_away_stat_collector(team, game)
          elsif game.type == "R"
            regular_away_stat_collector(team, game)
          end
        end
      end
    end
    calculate_season_statistics(@teams)
  end


  def home_team_stat_collector(team, game)
    team.home_games += 1
    team.total_games += 1
    team.matchup_games[game.away_team_id] += 1
    team.home_goals_scored += game.home_goals
    team.total_goals_scored += game.home_goals
    team.total_goals_allowed += game.away_goals
    if game.home_goals > game.away_goals
      team.home_wins += 1
      team.total_wins += 1
      team.matchup_wins[game.away_team_id] += 1
    end
  end

  def away_team_stat_collector(team, game)
    team.away_games += 1
    team.total_games += 1
    team.matchup_games[game.home_team_id] += 1
    team.away_goals_scored += game.away_goals
    team.total_goals_scored += game.away_goals
    team.total_goals_allowed += game.home_goals
    if game.away_goals > game.home_goals
      team.away_wins += 1
      team.total_wins += 1
      team.matchup_wins[game.home_team_id] += 1
    end
  end

  def preseason_home_stat_collector(team, game)
    team.preseason_games[game.season] += 1
    team.preseason_goals_scored[game.season] += game.home_goals
    team.preseason_goals_against[game.season] += game.away_goals
    if game.home_goals > game.away_goals
      team.preseason_wins[game.season] += 1
    end
  end

  def preseason_away_stat_collector(team, game)
    team.preseason_games[game.season] += 1
    team.preseason_goals_scored[game.season] += game.away_goals
    team.preseason_goals_against[game.season] += game.home_goals
    if game.away_goals > game.home_goals
      team.preseason_wins[game.season] += 1
    end
  end

  def regular_home_stat_collector(team, game)
    team.regular_games[game.season] += 1
    team.regular_goals_scored[game.season] += game.home_goals
    team.regular_goals_against[game.season] += game.away_goals
    if game.home_goals > game.away_goals
      team.regular_wins[game.season] += 1
    end
  end

  def regular_away_stat_collector(team, game)
    team.regular_games[game.season] += 1
    team.regular_goals_scored[game.season] += game.away_goals
    team.regular_goals_against[game.season] += game.home_goals
    if game.away_goals > game.home_goals
      team.regular_wins[game.season] += 1
    end
  end

  def calculate_season_statistics(teams)
    teams.each do |team|
      team.home_win_percentage = team.home_wins.to_f / team.home_games.to_f
      team.away_win_percentage = team.away_wins.to_f / team.away_games.to_f
      team.average_goals_scored = (team.total_goals_scored.to_f / team.total_games.to_f).round(2)
      team.average_goals_allowed = (team.total_goals_allowed.to_f / team.total_games.to_f).round(2)
      team.home_minus_away_percentage = team.home_win_percentage - team.away_win_percentage
      team.average_home_goals = (team.home_goals_scored.to_f / team.home_games.to_f).round(2)
      team.average_away_goals = (team.away_goals_scored.to_f / team.away_games.to_f).round(2)
      team.total_win_percentage = (team.home_win_percentage + team.away_win_percentage) / 2.0
      team.matchup_games.keys.each do |rival|
        team.matchup_win_percentage[rival] = (team.matchup_wins[rival].to_f / team.matchup_games[rival].to_f).round(2)
      end
      team.regular_games.keys.each do |season|
        team.regular_win_percentage[season] = team.regular_wins[season].to_f / team.regular_games[season].to_f
        team.regular_average_goals_scored[season] = team.regular_goals_scored[season].to_f / team.regular_games[season].to_f
        team.regular_average_goals_against[season] = team.regular_goals_against[season].to_f / team.regular_games[season].to_f
      end
      team.preseason_games.keys.each do |season|
        team.preseason_win_percentage[season] = team.preseason_wins[season].to_f / team.preseason_games[season].to_f
        team.preseason_average_goals_scored[season] = team.preseason_goals_scored[season].to_f / team.preseason_games[season].to_f
        team.preseason_average_goals_against[season] = team.preseason_goals_against[season].to_f / team.preseason_games[season].to_f
        team.preseason_to_regular_increase[season] = team.regular_win_percentage[season] - team.preseason_win_percentage[season]
      end
    end
  end
end

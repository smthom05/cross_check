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
end

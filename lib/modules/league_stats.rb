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

  def collect_season_stats(season)
    @games.each do |game|
      @teams.each do |team|
        if game.home_team_id == team.team_id && game.season == season
          if game.type == "P"
            preseason_home_stat_collector(team, game)
          elsif game.type == "R"
            regular_home_stat_collector(team, game)
          end
        elsif game.away_team_id == team.team_id && game.season == season
          if game.type == "P"
            preseason_away_stat_collector(team, game)
          elsif game.type == "R"
            regular_away_stat_collector(team, game)
          end
        end
      end
    end
  end


  def home_team_stat_collector(team, game)
    team.home_games += 1
    team.total_games += 1
    team.home_goals_scored += game.home_goals
    team.total_goals_scored += game.home_goals
    team.total_goals_allowed += game.away_goals
    if game.home_goals > game.away_goals
      team.home_wins += 1
      team.total_wins += 1
    end
  end

  def away_team_stat_collector(team, game)
    team.away_games += 1
    team.total_games += 1
    team.away_goals_scored += game.away_goals
    team.total_goals_scored += game.away_goals
    team.total_goals_allowed += game.home_goals
    if game.away_goals > game.home_goals
      team.away_wins += 1
      team.total_wins += 1
    end
  end

  def preseason_home_stat_collector(team, game)
    team.preseason_games += 1
    team.preseason_goals_scored += game.home_goals
    team.preseason_goals_against += game.away_goals
    if game.home_goals > game.away_goals
      team.preseason_wins += 1
    end
  end

  def preseason_away_stat_collector(team, game)
    team.preseason_games += 1
    team.preseason_goals_scored += game.away_goals
    team.preseason_goals_against += game.home_goals
    if game.away_goals > game.home_goals
      team.preseason_wins += 1
    end
  end

  def regular_home_stat_collector(team, game)
    team.regular_games += 1
    team.regular_goals_scored += game.home_goals
    team.regular_goals_against += game.away_goals
    if game.home_goals > game.away_goals
      team.regular_wins += 1
    end
  end

  def regular_away_stat_collector(team, game)
    team.regular_games += 1
    team.regular_goals_scored += game.away_goals
    team.regular_goals_against += game.home_goals
    if game.away_goals > game.home_goals
      team.regular_wins += 1
    end
  end
end

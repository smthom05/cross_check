module Templates
  def team_info_hash(team_id)
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

  def season_summary_hash(season, team_id)
    team = @teams.select { |each_team| each_team.team_id == team_id }.first

    preseason_hash = {
      win_percentage: team.preseason_win_percentage[season].round(2),
      goals_scored: team.preseason_goals_scored[season],
      goals_against: team.preseason_goals_against[season]
    }
    regular_hash = {
      win_percentage: team.regular_win_percentage[season].round(2),
      goals_scored: team.regular_goals_scored[season],
      goals_against: team.regular_goals_against[season]
    }
    {
      preseason: preseason_hash,
      regular_season: regular_hash
    }
  end

  def seasonal_summary_hash(team_id)
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
end

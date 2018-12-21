module ScoreFinder
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

  def generate_number_of_games_by_team_id(csv)
    team_games_by_id = Hash.new(0)

    csv.each do |game|
      team_games_by_id[game.team_id] += 1
    end
    team_games_by_id
  end

  def generate_scores_by_team_id(csv)
    team_scores_by_id = Hash.new(0)

    csv.each do |team|
      team_scores_by_id[team.team_id] = 0
    end
    team_scores_by_id
  end

  def add_goals_by_home_or_away(location, team_scores_by_id)
    if location == "home"
      game_teams.each do |game|
        if game.hoa == "home"
          team_scores_by_id[game.team_id] += game.goals
        end
      end
    else location == "away"
      game_teams.each do |game|
        if game.hoa == "away"
          team_scores_by_id[game.team_id] += game.goals
        end
      end
    end
    team_scores_by_id
  end

  def average_goals_per_game_by_team(goals_hash, games_hash)
    average_hash = goals_hash.merge(games_hash){|key, old, new| Array(old).push(new)}

    average_hash.each do |id, value|
      average_hash[id] = value[0].to_f / value[1].to_f
    end
    average_hash
  end

  def highest_scoring_team(hash)
    highest_score = 0
    hash.each do |_, score|
      if score > highest_score
        highest_score = score
      end
    end

    best_scoring_id = nil 
    hash.each do |id, score|
      if score == highest_score
        best_scoring_id = id
      end
    end

    teams.each do |team|
      if best_scoring_id == team.team_id
        return team.team_name
      end
    end
  end

  def lowest_scoring_team(hash)
    lowest_score = 10.0
    hash.each do |_, score|
      if score < lowest_score
        lowest_score = score
      end
    end

    worst_home_id = "0"
    hash.each do |id, score|
      if score == lowest_score
        worst_home_id = id
      end
    end

    teams.each do |team|
      if worst_home_id == team.team_id
        return team.team_name
      end
    end
  end
end

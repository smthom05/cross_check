class Team
  attr_reader :team_id,
              :franchise_id,
              :short_name,
              :team_name,
              :abbreviation,
              :link
  attr_accessor :home_games,
                :away_games,
                :total_games,
                :home_wins,
                :away_wins,
                :total_wins,
                :home_goals_scored,
                :away_goals_scored,
                :total_goals_scored,
                :total_goals_allowed,
                :preseason_games,
                :preseason_wins,
                :regular_games,
                :regular_wins,
                :preseason_goals_scored,
                :preseason_goals_against,
                :regular_goals_scored,
                :regular_goals_against,
                :preseason_win_percentage,
                :regular_win_percentage,
                :preseason_average_goals_scored,
                :regular_average_goals_scored,
                :preseason_average_goals_against,
                :regular_average_goals_against
  def initialize(attribute_array)
    @team_id = attribute_array[0].to_i
    @franchise_id = attribute_array[1].to_i
    @short_name = attribute_array[2]
    @team_name = attribute_array[3]
    @abbreviation = attribute_array[4]
    @link = attribute_array[5]
    @home_games = 0
    @away_games = 0
    @total_games = 0
    @home_wins = 0
    @away_wins = 0
    @total_wins = 0
    @home_goals_scored = 0
    @away_goals_scored = 0
    @total_goals_scored = 0
    @total_goals_allowed = 0
    @preseason_games = 0
    @preseason_wins = 0
    @regular_games = 0
    @regular_wins = 0
    @preseason_goals_scored = 0
    @preseason_goals_against = 0
    @regular_goals_scored = 0
    @regular_goals_against = 0
    @preseason_win_percentage = 0
    @regular_win_percentage = 0
    @preseason_average_goals_scored = 0
    @regular_average_goals_scored = 0
    @preseason_average_goals_against = 0
    @regular_average_goals_against = 0
  end

  def reset
    @preseason_games = 0
    @preseason_wins = 0
    @regular_games = 0
    @regular_wins = 0
    @preseason_goals_scored = 0
    @preseason_goals_against = 0
    @regular_goals_scored = 0
    @regular_goals_against = 0
    @preseason_win_percentage = 0
    @regular_win_percentage = 0
    @preseason_average_goals_scored = 0
    @regular_average_goals_scored = 0
    @preseason_average_goals_against = 0
    @regular_average_goals_against = 0
  end
end

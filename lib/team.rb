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
                :total_goals_allowed
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
  end
end

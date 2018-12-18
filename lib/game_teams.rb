class GameTeams
  attr_reader :game_id,
              :team_id,
              :hoa,
              :won,
              :settled_in,
              :head_coach,
              :goals,
              :shots,
              :hits,
              :pim,
              :powerPlayOpportunities,
              :powerPlayGoals,
              :faceOffWinPercentage,
              :giveaways,
              :takeaways
  def initialize(attribute_array)
    @game_id = attribute_array[0]
    @team_id = attribute_array[1]
    @hoa = attribute_array[2]
    @won = attribute_array[3]
    @settled_in = attribute_array[4]
    @head_coach = attribute_array[5]
    @goals = attribute_array[6]
    @shots = attribute_array[7]
    @hits = attribute_array[8]
    @pim = attribute_array[9]
    @powerPlayOpportunities = attribute_array[10]
    @powerPlayGoals =  attribute_array[11]
    @faceOffWinPercentage = attribute_array[12]
    @giveaways = attribute_array[13]
    @takeaways = attribute_array[14]
  end

  def won?
    if @won == "TRUE"
      return true
    elsif @won == "FALSE"
      return false
    end
  end
end

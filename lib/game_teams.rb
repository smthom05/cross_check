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
    @game_id = attribute_array[0].to_i
    @team_id = attribute_array[1].to_i
    @hoa = attribute_array[2]
    @won = attribute_array[3]
    @settled_in = attribute_array[4]
    @head_coach = attribute_array[5]
    @goals = attribute_array[6].to_i
    @shots = attribute_array[7].to_i
    @hits = attribute_array[8].to_i
    @pim = attribute_array[9].to_i
    @powerPlayOpportunities = attribute_array[10].to_i
    @powerPlayGoals =  attribute_array[11].to_i
    @faceOffWinPercentage = attribute_array[12].to_f
    @giveaways = attribute_array[13].to_i
    @takeaways = attribute_array[14].to_i
  end

  def won?
    if @won == "TRUE"
      true
    elsif @won == "FALSE"
      false
    end
  end
end

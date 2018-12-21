class Team
  attr_reader :team_id,
              :franchise_id,
              :short_name,
              :team_name,
              :abbreviation,
              :link
  def initialize(attribute_array)
    @team_id = attribute_array[0].to_i
    @franchise_id = attribute_array[1].to_i
    @short_name = attribute_array[2]
    @team_name = attribute_array[3]
    @abbreviation = attribute_array[4]
    @link = attribute_array[5]
  end

  def return_team_name_by_id(id)
      if id == team.team_id
        return team.team_name
      end
  end
end

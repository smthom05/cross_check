class Game
  attr_reader :team_id,
              :franchise_id,
              :short_name,
              :team_name,
              :abbreviation,
              :link
  def initialize(attribute_array)
    @team_id = attribute_array[0]
    @franchise_id = attribute_array[1]
    @short_name = attribute_array[2]
    @team_name = attribute_array[3]
    @abbreviation = attribute_array[4]
    @link = attribute_array[5]
  end
end

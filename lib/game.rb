class Game
  attr_reader :game_id,
              :season,
              :type,
              :date_time,
              :away_team_id,
              :home_team_id,
              :away_goals,
              :home_goals,
              :outcome,
              :home_rink_side_start,
              :venue,
              :venue_link,
              :venue_time_zone_id,
              :venue_time_zone_offset,
              :venue_time_zone_tz
  def initialize(attribute_array)
    @game_id = attribute_array[0]
    @season = attribute_array[1]
    @type = attribute_array[2]
    @date_time = attribute_array[3]
    @away_team_id = attribute_array[4]
    @home_team_id = attribute_array[5]
    @away_goals = attribute_array[6].to_i
    @home_goals = attribute_array[7].to_i
    @outcome = attribute_array[8]
    @home_rink_side_start = attribute_array[9]
    @venue = attribute_array[10]
    @venue_link = attribute_array[11]
    @venue_time_zone_id = attribute_array[12]
    @venue_time_zone_offset = attribute_array[13]
    @venue_time_zone_tz = attribute_array[14]
  end
end

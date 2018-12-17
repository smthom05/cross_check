require 'csv'
class StatTracker
  def self.from_csv(location)
    CSV.readlines(location)[1,5]
  end
end

p StatTracker.from_csv("./data/game_teams_stats.csv")

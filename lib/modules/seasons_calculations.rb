module SeasonsCalculations
  def season_with_most_games
    seasons = []
    @games.each do |game|
      seasons << game.season
    end
    (seasons.max_by {|season| seasons.count(season)})
  end

  def season_with_fewest_games
    seasons = []
    @games.each do |game|
      seasons << game.season
    end
    (seasons.min_by {|season| seasons.count(season)})
  end
end

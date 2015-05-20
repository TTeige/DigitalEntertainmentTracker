class HomeController < ApplicationController
  def index
    series = SeriesInformation.order("userssubscribed DESC").pluck(:seriesid)
    @upcoming = Array.new
    i = 0
    while i < series.length
      seriesInformation = get_information_for_seriesid(series[i])
      episodes = get_upcoming_episodes(series[i])
      for episode in episodes
        @upcoming.push([seriesInformation.seriesname,episode.firstaired,episode.episodename,series[i],episode.id])
      end
      if(@upcoming.length>10)
        break
      end
      i+=1
    end
    @upcoming.sort! { |x,y|
      x[1] <=> y[1]
    }
    @upcoming = @upcoming[0..10]
  end

  def about
  end
end

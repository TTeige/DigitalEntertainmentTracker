class HomeController < ApplicationController
  def index
    most_tracked_list = Hash.new(0)
    SeriesSubscription.find_each do |subscription|
      most_tracked_list[subscription.seriesid]=most_tracked_list[subscription.seriesid]+1
    end
    series = most_tracked_list.sort_by{ |seriesid, count| count }.reverse[0..7]
    @upcoming = Array.new
    i = 0
    while i < series.length
      @upcoming.concat(get_upcoming_episodes(series[i][0]))
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

class HomeController < ApplicationController
  def index
    most_tracked_list = Hash.new(0)
    SeriesSubscription.find_each do |subscription|
      most_tracked_list[subscription.seriesid]=most_tracked_list[subscription.seriesid]+1
    end
    series = most_tracked_list.sort_by{ |seriesid, count| count }.reverse[0..5]
    client = TheTvDbParty::Client.new(ENV['TVDB_API_KEY'])
    @baseRecords = Array.new(series.length)
    i = 0
    # Populate list with base series records
    while i < series.length
      @baseRecords[i] = client.get_base_series_record(series[i][0])
      i+=1
    end
    @baseRecords.sort! { |x,y|
      # Ensures that null entries are placed at the bottom of the list.
      if y.airs_time==nil && x.airs_time==nil
        0
      elsif y.airs_time==nil
        -1
      elsif x.airs_time==nil
        1
      # Special case to always put daily on top. This might not be necessary as "Daily" seems to use todays date by default. However this groups them together at the top.
      elsif x.airs_dayofweek == "Daily"
        -1
      elsif y.airs_dayofweek == "Daily"
        1
      # If no special case, sort by airs_time
      else
        x.airs_time <=> y.airs_time
      end
    }
  end

  def about
  end
end

class HomeController < ApplicationController
  def index
    client = TheTvDbParty::Client.new "5CB46CA60629B0DD"
    # NOTE: This would actually be retrieved results from our cache database. This is only for demonstration purposes.
    # The result is sliced for speed and request count limitation
    searchResults = (client.search "The")[0..5]
    @baseRecords = Array.new(searchResults.length)
    i = 0
    # Populate list with base series records
    while i < searchResults.length
      @baseRecords[i] = searchResults[i].get_base_series_record
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

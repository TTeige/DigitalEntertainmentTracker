class HomeController < ApplicationController
  def index
    client = TVdb::Client.new(ENV['TVDB_API_KEY'])
    # Should look in local database of popular shows for shows to display
    results = client.search('The')# + client.search('Firefly')
    # Should be list of shows
    @shows = results.sort {|x,y|
      
      #elsif x.airs_dayofweek == "Daily"
      #  -1
      #elsif y.airs_dayofweek == "Daily"
      #  1
      if x.airs_dayofweek == y.airs_dayofweek
        x.seriesname <=> y.seriesname
      elsif x.airs_dayofweek.empty?
        1
      elsif y.airs_dayofweek.empty?
        -1
      else
        case x.airs_dayofweek
        when "Monday"
          x_num=1
        x.airs_dayofweek <=> y.airs_dayofweek
      end
      }
  end
end

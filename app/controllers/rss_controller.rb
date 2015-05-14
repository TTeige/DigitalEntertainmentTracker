class RssController < ApplicationController
	def feed
		most_tracked_list = Hash.new(0)
	    SeriesSubscription.find_each do |subscription|
	      most_tracked_list[subscription.seriesid]=most_tracked_list[subscription.seriesid]+1
	    end
	    series = most_tracked_list.sort_by{ |seriesid, count| count }.reverse[0..7]
	    client = TheTvDbParty::Client.new(ENV['TVDB_API_KEY'])
	    @upcoming = Array.new
	    i = 0
	    while i < series.length
	      full_record = client.get_series_all(series[i][0]).full_series_record
	      for j in 1..(full_record.episodes.length)
	        if(full_record.episodes[full_record.episodes.length-j].firstaired)
	          if(full_record.episodes[full_record.episodes.length-j].firstaired > Date.today)
	            @upcoming.push([full_record.seriesname,
	                            full_record.episodes[full_record.episodes.length-j].firstaired,
	                            full_record.episodes[full_record.episodes.length-j].episodename,
	                            full_record.seriesid])
	          else
	            break
	          end
	        end
	      end
	      i+=1
	    end
	    @upcoming.sort! { |x,y|
	      x[1] <=> y[1]
	    }
	    @upcoming = @upcoming[0..10]

	  end

	
end

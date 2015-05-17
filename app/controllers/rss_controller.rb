class RssController < ApplicationController

	def feed
   @upcoming = Array.new
    client = TheTvDbParty::Client.new(ENV['TVDB_API_KEY'])
    series_subscriptions = current_user.series_subscriptions
    for subscr in current_user.series_subscriptions.map
      full_record = client.get_series_all(subscr.seriesid).full_series_record
      for j in 1..(full_record.episodes.length)
        if(full_record.episodes[full_record.episodes.length-j].firstaired)
          if(full_record.episodes[full_record.episodes.length-j].firstaired > Date.today - 10)
          	episodename = full_record.episodes[full_record.episodes.length-j].episodename
          
          	if (!episodename)
          		episodename = "TBA"
          	end 
 
          	overview = full_record.episodes[full_record.episodes.length - j].overview
          	if (!overview)
          		overview = "No released episode info!"
          	end

           @upcoming.push([full_record.seriesname,
                            full_record.episodes[full_record.episodes.length-j].firstaired,
                            episodename,
                            full_record.seriesid,
                            overview,
                            full_record.episodes[full_record.episodes.length - j].imagepath_full])

            				

          else
            break
          end
        end
      end
    end
    @upcoming.sort! { |x,y|
      x[1] <=> y[1]
    }
  end

	
end



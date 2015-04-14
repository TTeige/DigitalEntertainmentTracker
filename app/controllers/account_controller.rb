class AccountController < ApplicationController

  before_action :authenticate_user!

  def index
    @upcoming = Array.new
    client = TheTvDbParty::Client.new(ENV['TVDB_API_KEY'])
    series_subscriptions = current_user.series_subscriptions
    for subscr in current_user.series_subscriptions.map
      full_record = client.get_series_all(subscr.seriesid).full_series_record
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
    end
    @upcoming.sort! { |x,y|
      x[1] <=> y[1]
    }
  end

  def subscriptions
    client = TheTvDbParty::Client.new(ENV['TVDB_API_KEY'])
    series_subscriptions = current_user.series_subscriptions

    @subscribed_series_records = series_subscriptions.map do |subscr|
      client.get_base_series_record subscr.seriesid
    end
  end
end

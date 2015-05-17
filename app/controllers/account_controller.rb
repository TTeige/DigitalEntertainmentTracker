class AccountController < ApplicationController

  before_action :authenticate_user!

  def index
    @upcoming = Array.new
    series_subscriptions = current_user.series_subscriptions
    for subscr in current_user.series_subscriptions.map
      seriesInformation = get_information_for_seriesid(subscr.seriesid)
      episodes = get_upcoming_episodes(subscr.seriesid)
      for episode in episodes
        @upcoming.push([seriesInformation.seriesname,episode.firstaired,episode.episodename,subscr.seriesid])
      end
    end
    @upcoming.sort! { |x,y|
      x[1] <=> y[1]
    }
  end

  def subscriptions
    # client = TheTvDbParty::Client.new(ENV['TVDB_API_KEY'])
    series_subscriptions = current_user.series_subscriptions

    @subscribed_series = series_subscriptions.map do |subscr|
      #client.get_base_series_record subscr.seriesid
      get_information_for_seriesid(subscr.seriesid)
    end
  end
end

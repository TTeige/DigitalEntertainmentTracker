class AccountController < ApplicationController

  before_action :authenticate_user!

  def index
    @upcoming = Array.new
    series_subscriptions = current_user.series_subscriptions
    for subscr in current_user.series_subscriptions.map
      @upcoming.concat(get_upcoming_episodes(subscr.seriesid))
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

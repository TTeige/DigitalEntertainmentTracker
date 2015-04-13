class AccountController < ApplicationController

  before_action :authenticate_user!

  def index
  end

  def subscriptions
    client = TheTvDbParty::Client.new(ENV['TVDB_API_KEY'])
    series_subscriptions = current_user.series_subscriptions

    @subscribed_series_records = series_subscriptions.map do |subscr|
      client.get_base_series_record subscr.seriesid
    end
  end
end

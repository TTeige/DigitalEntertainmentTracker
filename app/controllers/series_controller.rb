class SeriesController < ApplicationController

	def show
		client = TheTvDbParty::Client.new(ENV['TVDB_API_KEY'])
    client.language = params[:lang] if params[:lang]
    @result = client.get_series_all(params[:seriesid])
    @full_rec = @result.full_series_record
  end

  def search
    client = TheTvDbParty::Client.new(ENV['TVDB_API_KEY'])
    @query = params[:query]
    client.language = params[:lang] if params[:lang]

    @results = client.search(@query)
  end

  def subscribe
    if current_user
      seriesid = params[:seriesid]

      subscription = SeriesSubscription.find_by :user => current_user, :seriesid => seriesid
      unless subscription
        subscription = SeriesSubscription.new(:user => current_user, :seriesid => seriesid)
        subscription.save
      end

      redirect_to action: :show, seriesid: seriesid, status: 307
    else
      render :text => "You have to login to subscribe to a TV show!", :status => :unauthorized, content_type: 'text/plain'
    end
  end

end

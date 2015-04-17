class SeriesController < ApplicationController

  before_action :authenticate_user!, only: [:subscribe]

	def show
		client = TheTvDbParty::Client.new(ENV['TVDB_API_KEY'])
    client.language = params[:lang] if params[:lang]
    @result = client.get_series_all(params[:seriesid])
    @full_rec = @result.full_series_record


    @next_airing_list = Array.new
    @num_seasons = 0
    @full_rec.episodes.each do |e|
      if e.seasonnumber > @num_seasons
        @num_seasons = e.seasonnumber
      end

      if @next_airing_list.size > 10
        next
      end
      if e.firstaired > Date.today
        @next_airing_list << e
      end

    end

    @num_seasons += 1

    @seasons = Array.new(@num_seasons)
    @seasons.each_with_index do |s , i|
      s = Array.new
      @full_rec.episodes.each do |e|
        if e.seasonnumber == i
          s << e
        end
      @seasons[i] = s
      end
    end



  end

  def search
    client = TheTvDbParty::Client.new(ENV['TVDB_API_KEY'])
    @query = params[:query]
    client.language = params[:lang] if params[:lang]

    @results = client.search(@query)
  end

  def subscribe
    seriesid = params[:seriesid]

    subscription = SeriesSubscription.find_by :user => current_user, :seriesid => seriesid
    unless subscription
      subscription = SeriesSubscription.new(:user => current_user, :seriesid => seriesid)
      subscription.save
    end

    redirect_to action: :show, seriesid: seriesid, status: 307
  end

end

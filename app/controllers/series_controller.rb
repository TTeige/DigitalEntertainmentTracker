class SeriesController < ApplicationController

	def show
		client = TheTvDbParty::Client.new(ENV['TVDB_API_KEY'])
    client.language = params[:lang] if params[:lang]
    @result = client.get_series_all(params[:seriesid])
    @full_rec = @result.full_series_record

    @num_seasons = 0
    @full_rec.episodes.each do |e|
      if e.seasonnumber > @num_seasons
        @num_seasons = e.seasonnumber
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

end

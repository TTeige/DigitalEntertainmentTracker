class SeriesController < ApplicationController

	def show
		client = TheTvDbParty::Client.new(ENV['TVDB_API_KEY'])
		@results = client.search('The Big Bang Theory')			
  end

  def search
    client = TheTvDbParty::Client.new(ENV['TVDB_API_KEY'])
    @query = params[:query]

    @results = client.search(@query)
  end

end

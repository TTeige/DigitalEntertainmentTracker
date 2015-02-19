class SeriesController < ApplicationController

<<<<<<< HEAD
=======
	def show
		client = TheTvDbParty::Client.new(ENV['TVDB_API_KEY'])
		@results = client.search('The Big Bang Theory')
>>>>>>> master
  end

  def search
    client = TheTvDbParty::Client.new(ENV['TVDB_API_KEY'])
    @query = params[:query]
    client.language = params[:lang] if params[:lang]

    @results = client.search(@query)
  end

end

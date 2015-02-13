require 'tvdb'

class SeriesController < ApplicationController

	def create

	end


	def show
		client = TVdb::Client.new(ENV['TVDB_API_KEY'])
		@results = client.search('The Big Bang Theory')			
	end

end

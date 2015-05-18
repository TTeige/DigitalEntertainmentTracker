class EpisodesController < ApplicationController
  def show
    client = TheTvDbParty::Client.new(ENV['TVDB_API_KEY'])
    client.language = params[:lang] if params[:lang]
    @episodeid = params[:episodeid]
  end

  def absolute
    client = TheTvDbParty::Client.new(ENV['TVDB_API_KEY'])
    client.language = params[:lang] if params[:lang]
    @result = client.get_series_absolute_episode(params[:seriesid], params[:episode])
    render "base_episode_record"
  end

  def default
    client = TheTvDbParty::Client.new(ENV['TVDB_API_KEY'])
    client.language = params[:lang] if params[:lang]
    @result = client.get_series_season_episode(params[:seriesid], params[:season], params[:episode])
    render "base_episode_record"
  end

  def dvd
    client = TheTvDbParty::Client.new(ENV['TVDB_API_KEY'])
    client.language = params[:lang] if params[:lang]
    @result = client.get_series_dvd_season_episode(params[:seriesid], params[:season], params[:episode])
    render "base_episode_record"
  end

  def detail
    client = TheTvDbParty::Client.new(ENV['TVDB_API_KEY'])
    client.language = params[:lang] if params[:lang]
    @result = client.get_base_episode_record params[:episodeid]
    render "base_episode_record"
  end
end

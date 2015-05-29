class EpisodesController < ApplicationController
  def show
    # Check if episode exists in cache, otherwise fetch it
    # This does not add an episode to the cache as this method could be accessed from anywhere
    begin
      @result = EpisodeInformation.find(params[:episodeid])
      @seriesname = get_series_name(@result.seriesid)
      render "base_episode_record"
    rescue
      redirect_to action: 'detail', episodeid: params[:episodeid]
    end
  end

  def absolute
    client = TheTvDbParty::Client.new(ENV['TVDB_API_KEY'])
    client.language = params[:lang] if params[:lang]
    @result = client.get_series_absolute_episode(params[:seriesid], params[:episode])
    @seriesname = get_series_name(@result.seriesid)
    render "base_episode_record"
  end

  def default
    client = TheTvDbParty::Client.new(ENV['TVDB_API_KEY'])
    client.language = params[:lang] if params[:lang]
    @result = client.get_series_season_episode(params[:seriesid], params[:season], params[:episode])
    @seriesname = get_series_name(@result.seriesid)
    render "base_episode_record"
  end

  def dvd
    client = TheTvDbParty::Client.new(ENV['TVDB_API_KEY'])
    client.language = params[:lang] if params[:lang]
    @result = client.get_series_dvd_season_episode(params[:seriesid], params[:season], params[:episode])
    @seriesname = get_series_name(@result.seriesid)
    render "base_episode_record"
  end

  def detail
    client = TheTvDbParty::Client.new(ENV['TVDB_API_KEY'])
    if params[:lang]
      client.language = params[:lang]
    end
    @result = client.get_base_episode_record params[:episodeid]
    @seriesname = get_series_name(@result.seriesid)
    render "base_episode_record"
  end
  
  private
  def get_series_name(seriesid)
    client = TheTvDbParty::Client.new(ENV['TVDB_API_KEY'])
    begin
      return (SeriesInformation.find_by seriesid: @result.seriesid).seriesname
    rescue
      begin
        return client.get_base_series_record(seriesid).seriesname
      rescue
        return "Unknown"
      end
    end
  end
end

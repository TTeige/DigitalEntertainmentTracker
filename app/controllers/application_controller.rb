class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :get_upcoming_episodes
  helper_method :get_name_for_seriesid
  
  # Function to look for a series in the cache and retrieve all upcoming episodes
  # Returns: Array of arrays with data for an episode, each subarray is one episode.
  # Subarray order:
  # 0 = series name
  # 1 = episode air date
  # 2 = episode name (or blank if unknown)
  # 3 = series ID
  # 4 = episode number in season
  # 5 = season number in series
  # 6 = episode description
  # 7 = full path to banner art for episode (or nil if not available)
  def get_upcoming_episodes(seriesid)
    # See if we already have both a name for the series, if there exists a name episodes should be updated
    seriesName = SeriesName.find_by seriesid: seriesid
    upcomingEpisodes = EpisodeAirInformation.where(seriesid: seriesid)
    if seriesName.nil?
      seriesName,upcomingEpisodes = initialize_cache_and_return_data(seriesid)
    end
    # If, for some reason, neither database lookup or cache updating didn't return an array, create one.
    if upcomingEpisodes.nil?
      upcomingEpisodes = Array.new
    end
    upcoming_episodes_for_view = Array.new
    # Go through list of episodes found
    for j in 0..(upcomingEpisodes.length-1)
      # Check if episode is still in the future
      if(upcomingEpisodes[j].airdate > Date.today.prev_day)
        upcoming_episodes_for_view.push([seriesName.seriesname,
                              upcomingEpisodes[j].airdate,
                              upcomingEpisodes[j].episodename,
                              seriesid,
                              upcomingEpisodes[j].episodenum,
                              upcomingEpisodes[j].seasonnum,
                              upcomingEpisodes[j].description,
                              upcomingEpisodes[j].banner])
      else
        # If not, delete it (should be safe to do here as the data is only removed from database, not from array)
        # NOTE: This is the only place old episodes are pruned out when updates are not occurring. This should probably also be in a cleanup function. 
        upcomingEpisodes[j].delete
      end
    end
    return upcoming_episodes_for_view
  end
  
  # Function to get series name from on id by looking in the cache database. If the name is not found, go fetch the name (and update the cache at the same time).
  # NOTE: SeriesName is actually a model containing more information than just the name, see db/schema.rb for more information
  def get_name_for_seriesid(seriesid)
    seriesName = SeriesName.find_by seriesid: seriesid
    if seriesName.nil?
      seriesName,_ = initialize_cache_and_return_data(seriesid)
    end
    return seriesName.seriesname
  end
  
  # Internal function to look up things in the cache. Adds episodes without checking if they already exists! 
  def initialize_cache_and_return_data(seriesid)
    # Create a TvDBParty client and fetch the episode record
    client = TheTvDbParty::Client.new(ENV['TVDB_API_KEY'])
    full_record = client.get_series_all(seriesid).full_series_record
    seriesName = SeriesName.new
    seriesName.seriesid = seriesid
    seriesName.seriesname = full_record.seriesname
    seriesName.description = full_record.overview
    seriesName.genres = full_record.genres
    seriesName.save
    upcomingEpisodes = Array.new
    # Look through the episode record and see if we have any records that are not added
    for j in 1..(full_record.episodes.length)
      if(full_record.episodes[full_record.episodes.length-j].firstaired)
        if(full_record.episodes[full_record.episodes.length-j].firstaired > Date.today.prev_day)
          # If we find an episode which hasn't aired yet, or airs today, add it to the list.
          episodeAirInformation = EpisodeAirInformation.new
          episodeAirInformation.seriesid = seriesid
          episodeAirInformation.episodeid = full_record.episodes[full_record.episodes.length-j].id
          episodeAirInformation.episodename = full_record.episodes[full_record.episodes.length-j].episodename
          episodeAirInformation.airdate = full_record.episodes[full_record.episodes.length-j].firstaired
          episodeAirInformation.episodenum = full_record.episodes[full_record.episodes.length-j].episodenumber
          episodeAirInformation.seasonnum = full_record.episodes[full_record.episodes.length-j].seasonnumber
          episodeAirInformation.description = full_record.episodes[full_record.episodes.length-j].overview
          episodeAirInformation.banner = full_record.episodes[full_record.episodes.length-j].imagepath_full
          episodeAirInformation.save
          upcomingEpisodes.push(episodeAirInformation)
        else
          break
        end
      end
    end
    return seriesName,upcomingEpisodes
  end
  
  # Function to be added to cron-jobs by whenever gem
  def self.update_cache(lastupdate)
    client = TheTvDbParty::Client.new(ENV['TVDB_API_KEY'])
    timeDelta = (Time.new()-lastupdate).to_i
    timeframe = "day"
    if timeDelta>86400
      timeframe = "week"
      if timeDelta>604800
        timeframe = "month"
        if timeDelta>2592000
          timeframe = "all"
        end
      end
    end
    update = client.get_updates_by_timeframe(timeframe)
    subscribedSeries = Array.new
    SeriesSubscription.all.group(:seriesid).find_each do |series|
      subscribedSeries.push(series.seriesid)
    end
    seriesToUpdate = Array.new
    # Look at the edited series and add them to our update list
    for series in update.series
      if(series[:updatetime].to_i>lastupdate && subscribedSeries.index(series[:seriesid].to_i).nil? == false)
        seriesToUpdate.push(series[:seriesid])
      end
    end
    if(update.episodes.nil? == false )
      # Look at the edited episodes and determine if we should update their series
      for episode in update.episodes
        if(episode[:updatetime].to_i>lastupdate && subscribedSeries.index(episode[:seriesid].to_i).nil? == false && seriesToUpdate.index(episode[:seriesid]).nil? == true)
          seriesToUpdate.push(episode[:seriesid])
        end
      end
    end

    for seriesid in seriesToUpdate
      # Get information about the show
      full_record = client.get_series_all(seriesid).full_series_record
      seriesName = SeriesName.find_by seriesid: seriesid
      changed = false
      if(seriesName.seriesname != full_record.seriesname)
        seriesName.seriesname = full_record.seriesname
        changed = true
      end
      if(seriesName.description != full_record.overview)
        seriesName.description = full_record.overview
        changed = true
      end
      if(seriesName.genres != full_record.genres)
        seriesName.genres = full_record.genres
        changed = true
      end
      if(changed)
        seriesName.save
      end
      # Remove all episodes we have about the show
      EpisodeAirInformation.where(seriesid: seriesid).destroy_all
      
      # Go through the data and add in new episodes
      for j in 1..(full_record.episodes.length)
        if(full_record.episodes[full_record.episodes.length-j].firstaired)
          if(full_record.episodes[full_record.episodes.length-j].firstaired > Date.today.prev_day)
            # If we find an episode which hasn't aired yet, or airs today, add it to the list.
            episodeAirInformation = EpisodeAirInformation.new
            episodeAirInformation.seriesid = seriesid
            episodeAirInformation.episodeid = full_record.episodes[full_record.episodes.length-j].id
            episodeAirInformation.episodename = full_record.episodes[full_record.episodes.length-j].episodename
            episodeAirInformation.airdate = full_record.episodes[full_record.episodes.length-j].firstaired
            episodeAirInformation.episodenum = full_record.episodes[full_record.episodes.length-j].episodenumber
            episodeAirInformation.seasonnum = full_record.episodes[full_record.episodes.length-j].seasonnumber
            episodeAirInformation.description = full_record.episodes[full_record.episodes.length-j].overview
            episodeAirInformation.banner = full_record.episodes[full_record.episodes.length-j].imagepath_full
            episodeAirInformation.save
          else
            # As we go backwards through the episodes array we can break on the first episode which has already aired
            break
          end
        end
      end
    end
  end
end

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :get_upcoming_episodes
  helper_method :get_information_for_seriesid
  
  # Function to look for a series in the cache and retrieve all upcoming episodes
  # Returns: Array of EpisodeInformation models
  def get_upcoming_episodes(seriesid)
    # See if we already have both a name for the series, if there exists a name episodes should be updated
    seriesInformation = SeriesInformation.find_by seriesid: seriesid
    upcomingEpisodes = EpisodeInformation.where(seriesid: seriesid)
    if seriesInformation.nil?
      seriesInformation,upcomingEpisodes = initialize_cache_and_return_data(seriesid)
    end
    # If, for some reason, neither database lookup or cache updating didn't return an array, create one.
    if upcomingEpisodes.nil?
      upcomingEpisodes = Array.new
    end
    upcoming_episodes_for_return = Array.new
    # Go through list of episodes found
    for j in 0..(upcomingEpisodes.length-1)
      # Check if episode is still in the future
      if(upcomingEpisodes[j].firstaired > Date.today.prev_day)
        upcoming_episodes_for_return.push(upcomingEpisodes[j])
      else
        # If not, delete it (should be safe to do here as the data is only removed from database, not from array)
        # NOTE: This is the only place old episodes are pruned out when updates are not occurring. This should probably also be in a cleanup function. 
        upcomingEpisodes[j].delete
      end
    end
    return upcoming_episodes_for_return
  end
  
  # Function to get series name from on id by looking in the cache database. If the name is not found, go fetch the name (and update the cache at the same time).
  # NOTE: SeriesInformation is actually a model containing more information than just the name, see db/schema.rb for more information
  def get_information_for_seriesid(seriesid)
    seriesInformation = SeriesInformation.find_by seriesid: seriesid
    if seriesInformation.nil?
      seriesInformation,_ = initialize_cache_and_return_data(seriesid)
    end
    return seriesInformation
  end
  
  # Internal function to look up things in the cache. Adds episodes without checking if they already exists! 
  def initialize_cache_and_return_data(seriesid)
    begin
      # Create a TvDBParty client and fetch the episode record
      client = TheTvDbParty::Client.new(ENV['TVDB_API_KEY'])
      full_record = client.get_series_all(seriesid).full_series_record

      #Methods using the cache must handle the exception, creates a double render error when handled in this method
      if full_record.nil?
        raise ActionController::RoutingError.new('Internal Server Error')
      end

      seriesInformation = new_series_information_from_series_record(full_record)
      upcomingEpisodes = Array.new
      # Look through the episode record and see if we have any records that are not added
      for j in 1..(full_record.episodes.length)
        if(full_record.episodes[full_record.episodes.length-j].firstaired)
          if(full_record.episodes[full_record.episodes.length-j].firstaired > Date.today.prev_day)
            # If we find an episode which hasn't aired yet, or airs today, add it to the list.
            upcomingEpisodes.push(new_episode_information_from_episode_record(full_record.episodes[full_record.episodes.length-j]))
          else
            break
          end
        end
      end
      return seriesInformation,upcomingEpisodes
    end
  end
  
  # Function to be added to cron-jobs by whenever gem
  def update_cache(lastupdate)
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
      seriesInformation = SeriesInformation.find_by seriesid: seriesid
      if(seriesInformation.nil?)
        seriesInformation = new_series_information_from_series_record(full_record)
      end
      changed = false
      if(seriesInformation.seriesname != full_record.seriesname)
        seriesInformation.seriesname = full_record.seriesname
        changed = true
      end
      if(seriesInformation.overview != full_record.overview)
        seriesInformation.overview = full_record.overview
        changed = true
      end
      if(seriesInformation.genres != full_record.genres)
        seriesInformation.genres = full_record.genres
        changed = true
      end
      if(changed)
        seriesInformation.save
      end
      # Remove all episodes we have about the show
      EpisodeInformation.where(seriesid: seriesid).destroy_all
      
      # Go through the data and add in new episodes
      for j in 1..(full_record.episodes.length)
        if(full_record.episodes[full_record.episodes.length-j].firstaired)
          if(full_record.episodes[full_record.episodes.length-j].firstaired > Date.today.prev_day)
            # If we find an episode which hasn't aired yet, or airs today, add it to the list.
            new_episode_information_from_episode_record(full_record.episodes[full_record.episodes.length-j])
          else
            # As we go backwards through the episodes array we can break on the first episode which has already aired
            break
          end
        end
      end
    end
  end
  def new_episode_information_from_episode_record(episode_record)
    episodeInformation = EpisodeInformation.new
    episodeInformation.seriesid = episode_record.seriesid
    episodeInformation.id = episode_record.id
    episodeInformation.episodename = episode_record.episodename
    episodeInformation.firstaired = episode_record.firstaired
    episodeInformation.episodenumber = episode_record.episodenumber
    episodeInformation.seasonnumber = episode_record.seasonnumber
    episodeInformation.overview = episode_record.overview
    episodeInformation.imagepath_full = episode_record.imagepath_full
    episodeInformation.lastupdated = episode_record.lastupdated
    episodeInformation.save
    return episodeInformation
  end
  def new_series_information_from_series_record(series_record)
    seriesInformation = SeriesInformation.new
    seriesInformation.seriesid = series_record.seriesid
    seriesInformation.seriesname = series_record.seriesname
    seriesInformation.overview = series_record.overview
    seriesInformation.genres = series_record.genres
    # Do lookup in subscriptions table to ensure that this is right?
    seriesInformation.userssubscribed = 0
    seriesInformation.save
    return seriesInformation
  end

  protected
  def inter_server_error_render
    render(:file => File.join(Rails.root, 'public/404.html'), :status => 404, :layout => false)
  end

end

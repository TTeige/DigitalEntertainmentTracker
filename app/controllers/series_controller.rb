class SeriesController < ApplicationController

  before_action :authenticate_user!, only: [:subscribe, :unsubscribe]

	def show
    begin
  		client = TheTvDbParty::Client.new(ENV['TVDB_API_KEY'])
      client.language = params[:lang] if params[:lang]
      @result = client.get_series_all(params[:seriesid])
      @full_rec = @result.full_series_record

      if @full_rec.nil?
        raise ActionController::RoutingError.new('Internal Server Error')
      end
      
      #Bad way of sorting out the episodes in seasons, should be optimized
      @num_seasons = 0
      @full_rec.episodes.each do |e|
        if e.seasonnumber > @num_seasons
          @num_seasons = e.seasonnumber
        end unless e.seasonnumber.nil?
      end unless @full_rec.episodes.nil?

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

      @upcoming = search_for_upcoming(@full_rec)
      if @upcoming.nil?
        raise ActionController::RoutingError.new('Internal Server Error')
      end

    rescue ActionController::RoutingError
      inter_server_error_render
    end
  end


  def search
    client = TheTvDbParty::Client.new(ENV['TVDB_API_KEY'])
    @query = params[:query]
    client.language = params[:lang] if params[:lang]

    @results = client.search(@query)
  end

  def subscribe
    if params[:seriesid]
      seriesid = params[:seriesid]


      subscription = SeriesSubscription.find_by :user => current_user, :seriesid => seriesid
      unless subscription
        subscription = SeriesSubscription.new(:user => current_user, :seriesid => seriesid)
        subscription.save
        seriesinformation = get_information_for_seriesid(seriesid)
        unless seriesinformation.nil?
          seriesinformation.userssubscribed+=1
          seriesinformation.save
        end
      end

      redirect_to action: :show, seriesid: seriesid, status: 307
    else
      redirect_to controller: :account, action: :subscriptions
    end

  end

  def unsubscribe
    if params[:seriesid]
      seriesid = params[:seriesid]

      SeriesSubscription.destroy_all :user => current_user, :seriesid => seriesid
      seriesinformation = SeriesInformation.find_by :seriesid => seriesid
      unless seriesinformation.nil?
        seriesinformation.userssubscribed-=1
        if seriesinformation.userssubscribed>0
          seriesinformation.save
        elsif
          seriesinformation.destroy
          EpisodeInformation.where(seriesid: seriesid).destroy_all
        end
      end
    end

    redirect_to controller: :account, action: :subscriptions
  end

  def show_events
    begin
      if SeriesSubscription.find_by :seriesid => params[:seriesid]
        upcoming_episodes = get_upcoming_episodes(params[:seriesid])
      else
        client = TheTvDbParty::Client.new(ENV['TVDB_API_KEY'])
        client.language = params[:lang] if params[:lang]
        result = client.get_series_all(params[:seriesid])
        if result.nil?
          raise ActionController:RoutingError.new('Internal Server Errror')
        end
        upcoming_episodes = search_for_upcoming(result.full_series_record)
      end

      if upcoming_episodes.nil?
        raise ActionController::RoutingError.new('Internal Server Error')
      end

      events = upcoming_episodes.map do |e|
        puts e
        title = e.episodename.nil? ? "TBA" : e.episodename
        if e.firstaired.kind_of? Date
          x = create_calendar_event(e.id, title, e.overview, e.firstaired.to_datetime.utc.iso8601, e.firstaired.to_datetime.utc.iso8601)
        else
          x = create_calendar_event(e.id, title, e.overview, e.firstaired.utc.iso8601, e.firstaired.utc.iso8601)
        end
      end
      render json: events

    rescue ActionController::RoutingError
      inter_server_error_render
    end
  end

  private
  
  def create_calendar_event(id, title, description, start_time, end_time)
    return event = {:id => "#{id}", :title => "#{title}", :description => "#{description}", :start => "#{start_time}", :end => "#{end_time}"}
  end

  def search_for_upcoming(full_rec)
    upcoming_episodes = Array.new
    full_rec.episodes.each do |e|
      if e.firstaired.nil?
        next
      end
      if e.firstaired >= Date.today
        upcoming_episodes << e
      end
    end

    return upcoming_episodes
  end

end

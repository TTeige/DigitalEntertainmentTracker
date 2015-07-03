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

      @seasons_hash = Hash.new {|h,k| h[k]=[]}
      @full_rec.episodes.each do |e|
        @seasons_hash[e.seasonnumber ? e.seasonnumber : 0] << e
      end unless @full_rec.episodes.nil?

      @upcoming = search_for_upcoming
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
      upcoming_episodes = search_for_upcoming

      if upcoming_episodes.nil?
        raise ActionController::RoutingError.new('Internal Server Error')
      end

      events = upcoming_episodes.map do |e|
        title = e.episodename.nil? ? 'TBA' : e.episodename
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

  def ics_export
    upcoming = search_for_upcoming
    respond_to do |format|
      format.html
      format.ics do
        cal = Icalendar::Calendar.new
        upcoming.each do |e|
          event = Icalendar::Event.new
          if e.firstaired.kind_of? Date
            event.dtstart = e.firstaired.to_datetime
          else
            event.dtstart = e.firstaired
          end
          event.summary = e.episodename.nil? ? 'TBA' : e.episodename
          event.description = e.overview
          event.url = url_for :controller => 'series', :action => 'show', :seriesid => params[:seriesid]
          cal.add_event(event)
        end
        cal.publish
        render :text => cal.to_ical
      end
    end
  end


  private
  def create_calendar_event(id, title, description, start_time, end_time)
    {:id => "#{id}", :title => "#{title}", :description => "#{description}", :start => "#{start_time}", :end => "#{end_time}"}
  end

  def search_for_upcoming

    upcoming_episodes = Array.new
    if SeriesSubscription.find_by :seriesid => params[:seriesid]
      upcoming_episodes = get_upcoming_episodes(params[:seriesid])
    else
      client = TheTvDbParty::Client.new(ENV['TVDB_API_KEY'])
      client.language = params[:lang] if params[:lang]
      result = client.get_series_all(params[:seriesid])
      if result.nil?
        raise ActionController:RoutingError.new('Internal Server Errror')
      end
      result.full_series_record.episodes.each do |e|
        if e.firstaired.nil?
          next
        end
        if e.firstaired >= Date.today
          upcoming_episodes << e
        end
      end
    end
    upcoming_episodes
  end

  def events_as_hash

  end

end

class RssController < ApplicationController

	def feed
	  @upcoming = Array.new
	  userid = params[:userid]
	  if userid.nil? && current_user.nil? == false
	    redirect_to feed_path(:rss,:userid => current_user.id)
	  end
    unless userid.nil?
      params.merge(:b => 'goat')
      series_subscriptions = SeriesSubscription.where(user_id: userid)
      for subscr in series_subscriptions
        series = get_information_for_seriesid(subscr.seriesid)
        episodes = get_upcoming_episodes(subscr.seriesid)
        for episode in episodes
          @upcoming.push([series.seriesname,
                            episode.firstaired.strftime('%A, %B %-d, %Y'),
                            episode.episodename ? episode.episodename : "TBA",
                            series.seriesid,
                            episode.overview ? episode.overview : "No released episode info!",
                            episode.imagepath_full,
                            episode.episodenumber,
                            episode.seasonnumber,
                            episode.lastupdated.to_s[0..9]])
        end
      end
      @upcoming.sort! { |x,y|
        x[1] <=> y[1]
      }
    end
  end
end



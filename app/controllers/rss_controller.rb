class RssController < ApplicationController

	def feed
	  @upcoming = Array.new
	  userid = params[:userid]
	  key = params[:key]
	  if (userid.nil? || key.nil?) && current_user.nil? == false
	    redirect_to feed_path(:rss,:userid => current_user.id,:key => current_user.encrypted_password)
	  end
	  matchinguser = User.where(encrypted_password: key).first
    if userid.nil? == false && key.nil? == false && matchinguser.nil? == false
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
                            episode.lastupdated.strftime('%A, %B %-d, %Y %H:%m')])
        end
      end
      @upcoming.sort! { |x,y|
        x[1] <=> y[1]
      }
    end
  end
end



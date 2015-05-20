class RegistrationsController < Devise::RegistrationsController  
  def create
    if verify_recaptcha
      super
    else
      build_resource
      clean_up_passwords(resource)
      flash[:notice] = "There was an error with the recaptcha code below. Please re-enter the code and click submit."
      render :new
    end
  end
  def destroy
    # When a user is destroyed, unsubscribe from all series.
    for serie in current_user.series_subscriptions
      seriesinformation = SeriesInformation.find_by :seriesid => serie.seriesid
      unless seriesinformation.nil?
        seriesinformation.userssubscribed-=1
        if seriesinformation.userssubscribed>0
          seriesinformation.save
        elsif
          seriesinformation.destroy
          EpisodeInformation.where(seriesid: serie.seriesid).destroy_all
        end
      end
      serie.destroy
    end
    super
  end
end
require 'rails_helper'

RSpec.describe SeriesController, type: :controller do
  describe "GET #show" do
    it "returns success if show has been found" do
      get :show, :seriesid => "121361"
      expect(response).to have_http_status(200)
    end

    it "returns 404 not found when invalid series id" do 
      get :show,  :seriesid => "abc"
      expect(response).to have_http_status(404)
    end

  end

  describe "GET #show_events" do
    it "returns success if rendered" do 
      get :show_events, :seriesid => "121361"
      expect(response).to have_http_status(200)
    end

    it "returns 404 not found when invalid series id" do 
      get :show_events,  :seriesid => "abc"
      expect(response).to have_http_status(404)
    end
  end

end

require 'rails_helper'

RSpec.describe SeriesController, type: :controller do
  describe "GET #show" do
    it "returns success if show has been found" do
      get :show
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #show_events" do
    it "returns success if rendered" do 
      get :show_events
      expect(response).to have_http_status(200)
    end
  end

end

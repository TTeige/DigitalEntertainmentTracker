require 'rails_helper'

RSpec.describe EpisodesController, type: :controller do

  describe "GET #show" do
    it "returns http success" do
      get :show
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #detail" do
    it "returns http success" do
      get :detail
      expect(response).to have_http_status(:success)
    end
  end

end

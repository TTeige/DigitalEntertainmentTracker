require 'rails_helper'

RSpec.feature "Guest visiting landing page", :type => :feature do
  scenario "Guest visits" do
    visit "/home/index"
    
    expect(page).to have_text("Welcome to the Digital Entertainment Tracker!")
  end
end

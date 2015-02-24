require 'rails_helper'

RSpec.feature "Guest visiting landing page", :typ => :feature do
  scenario "Guest visits" do
    visit "/home/index"
    
    expect(page).to have_text("Welcome to the Digital Entertainment Tracker!")
    expect(page).to have_table("",:text => "The End of the Big Cats")
  end
end

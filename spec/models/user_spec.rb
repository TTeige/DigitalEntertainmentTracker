require 'rails_helper'


RSpec.describe User, type: :model do
	  
	context "Password Too Short"
	context "Successfully created"
	context "Email has already been taken"

	context "Invalid password"
	context "Invalid Email"
	context "Sign in"
	context "Sign Out"
	context "Update password"
	context "Update password error: New Password too short!"
	context "Update password error: Current password cant be blank"

	#NEEDS JS
	pending "Cancel Account"
	pending "Forgot Password Reactivation"


end

RSpec.feature "Create Account" do

	scenario "Password Too Short" do
	visit "/"
	click_link "Sign Up"
	fill_in "Email", with: "test@gmail.com"
	fill_in "Password", with: "qwerty"
	fill_in "Password confirmation", with: "qwerty"
	click_button "Sign up"
	expect(page).to have_content("Password is too short")
	end

	scenario "Successfully created" do
	visit "/"
	click_link "Sign Up"
	fill_in "Email", with: "test@gmail.com"
	fill_in "Password", with: "qwerty12"
	fill_in "Password confirmation", with: "qwerty12"
	click_button "Sign up"
	expect(page).to have_content("	Welcome! You have signed up successfully. ")
	end

	scenario "Email has already been taken" do
	visit "/"
	click_link "Sign Up"
	fill_in "Email", with: "test@gmail.com"
	fill_in "Password", with: "qwerty12"
	fill_in "Password confirmation", with: "qwerty12"
	click_button "Sign up"

	click_link "Sign out"
	click_link "Sign Up"
	fill_in "Email", with: "test@gmail.com"
	fill_in "Password", with: "qwerty12"
	fill_in "Password confirmation", with: "qwerty12"
	click_button "Sign up"
	expect(page).to have_content("Email has already been taken")
	end
end

RSpec.feature "Login and Edit" do

	scenario "Invalid password" do
	visit "/"
	click_link "Sign Up"
	fill_in "Email", with: "test@gmail.com"
	fill_in "Password", with: "qwerty12"
	fill_in "Password confirmation", with: "qwerty12"
	click_button "Sign up"
	click_link "Sign out"

	click_link "Sign In"
	fill_in "Email", with: "test@gmail.com"
	fill_in "Password", with: "qwerty"
	click_button "Log in"
	expect(page).to have_content("Invalid email or password. ")
	end

	scenario "Invalid Email" do
	visit "/"
	click_link "Sign Up"
	fill_in "Email", with: "test@gmail.com"
	fill_in "Password", with: "qwerty12"
	fill_in "Password confirmation", with: "qwerty12"
	click_button "Sign up"
	click_link "Sign out"

	click_link "Sign In"
	fill_in "Email", with: "test22@gmail.com"
	fill_in "Password", with: "qwerty12"
	click_button "Log in"
	expect(page).to have_content("Invalid email or password. ")
	end

	scenario "Sign Out" do
	visit "/"
	click_link "Sign Up"
	fill_in "Email", with: "test@gmail.com"
	fill_in "Password", with: "qwerty12"
	fill_in "Password confirmation", with: "qwerty12"
	click_button "Sign up"
	click_link "Sign out"
	expect(page).to have_content("Signed out successfully.")
	end

	scenario "Sign In" do
	visit "/"
	click_link "Sign Up"
	fill_in "Email", with: "test@gmail.com"
	fill_in "Password", with: "qwerty12"
	fill_in "Password confirmation", with: "qwerty12"
	click_button "Sign up"
	click_link "Sign out"
	
	click_link "Sign In"
	fill_in "Email", with: "test@gmail.com"
	fill_in "Password", with: "qwerty12"
	click_button "Log in"
	expect(page).to have_content("Signed in successfully.")
	end

	scenario "Update password" do
	visit "/"
	click_link "Sign Up"
	fill_in "Email", with: "test@gmail.com"
	fill_in "Password", with: "qwerty12"
	fill_in "Password confirmation", with: "qwerty12"
	click_button "Sign up"
	click_link "Sign out"
	
	click_link "Sign In"
	fill_in "Email", with: "test@gmail.com"
	fill_in "Password", with: "qwerty12"
	click_button "Log in"

	click_link "Edit"

	fill_in "Password", with: "qwerty123"
	fill_in "Password confirmation", with: "qwerty123"
	fill_in "Current password", with: "qwerty12"
	click_button "Update"
	expect(page). to have_content ("Your account has been updated successfully.")
	end

	scenario "Update password error: Password corfirmation does not match" do
	visit "/"
	click_link "Sign Up"
	fill_in "Email", with: "test@gmail.com"
	fill_in "Password", with: "qwerty12"
	fill_in "Password confirmation", with: "qwerty12"
	click_button "Sign up"
	click_link "Sign out"
	
	click_link "Sign In"
	fill_in "Email", with: "test@gmail.com"
	fill_in "Password", with: "qwerty12"
	click_button "Log in"

	click_link "Edit"

	fill_in "Password", with: "qwerty123"
	fill_in "Password confirmation", with: "qwerty1234"
	fill_in "Current password", with: "qwerty12"
	click_button "Update"
	expect(page). to have_content ("Password confirmation doesn't match Password")
	end

	scenario "Update password error: New Password too short!" do
	visit "/"
	click_link "Sign Up"
	fill_in "Email", with: "test@gmail.com"
	fill_in "Password", with: "qwerty12"
	fill_in "Password confirmation", with: "qwerty12"
	click_button "Sign up"
	click_link "Sign out"
	
	click_link "Sign In"
	fill_in "Email", with: "test@gmail.com"
	fill_in "Password", with: "qwerty12"
	click_button "Log in"

	click_link "Edit"

	fill_in "Password", with: "qwerty"
	fill_in "Password confirmation", with: "qwerty"
	fill_in "Current password", with: "qwerty12"
	click_button "Update"
	expect(page). to have_content ("Password is too short (minimum is 8 characters)")
	end


	scenario "Update password error: Current password can't be blank" do
	visit "/"
	click_link "Sign Up"
	fill_in "Email", with: "test@gmail.com"
	fill_in "Password", with: "qwerty12"
	fill_in "Password confirmation", with: "qwerty12"
	click_button "Sign up"
	click_link "Sign out"
	
	click_link "Sign In"
	fill_in "Email", with: "test@gmail.com"
	fill_in "Password", with: "qwerty12"
	click_button "Log in"

	click_link "Edit"

	fill_in "Password", with: "qwerty123"
	fill_in "Password confirmation", with: "qwerty123"
	fill_in "Current password", with: ""
	click_button "Update"
	expect(page). to have_content ("Current password can't be blank")
	end
end
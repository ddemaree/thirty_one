require 'spec_helper'
require 'capybara/rspec'

Capybara.app = ThirtyOne::App

feature "Submitting the form" do
  background do
    @secret_phrase = "44-massive-knishes"
    ThirtyOne::RandomPhrase.stub! generate: @secret_phrase
  end

  scenario "Registering as a new party" do
    visit "/register"
    fill_in "party[name]", with: "David Nemesis"
    fill_in "party[email]", with: "david@example.org"
    check "datetime_1203.8p"
    click_button "Save the date"

    page.should have_css("div.thanks .party-info")
    within(".party-info .secret-url") do
      page.should have_content("party/#{@secret_phrase}")
    end
  end

  scenario "Fixing problems with a registration" do
    visit "/register"
    fill_in "party[name]", with: "David Nemesis"
    fill_in "party[email]", with: "david@example.org"
    click_button "Save the date"

    page.should have_css(".error-messages")
    page.should have_content("You have to choose at least one time when you're available to par-tay")

    check "datetime_1203.6p"
    check "datetime_1203.8p"
    click_button "Save the date"

    page.should have_css("div.thanks .party-info")
  end
end

feature "Editing a response" do
  background do
    @party = FactoryGirl.create(:party)
  end
  
  scenario "Viewing my responses" do
    visit "/party/#{@party.unique_phrase}"
    page.should have_field "Your name", with: @party.name
    page.should have_field "Your email address", with: @party.email
    page.should have_checked_field "datetime_1203.8p"
  end
  
  scenario "Changing my response" do
    visit "/party/#{@party.unique_phrase}"
    fill_in "Your name", with: "Arnold Palmer"
    click_button "Save the date"
    
    # Now should be redirected back to this page with the new values
    page.should have_field "Your name", with: "Arnold Palmer"
  end
  
end
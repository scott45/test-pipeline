require "rails_helper"
require "spec_helper"

describe "Authentication test" do
  before(:all) do
    @bootcamper = create :bootcamper
  end

  after(:all) do
    Bootcamper.delete_all
  end

  feature "login page" do
    scenario "contains the title of the application" do
      visit("/login")
      expect(page).to have_content("VOF Tracker")
    end
  end

  feature "User login" do
    scenario "Users should not visit the dashboard without logging in" do
      visit("/")
      expect(page).to have_content("Login to view dashboard")
    end

    scenario "Users should visit the dashboard" do
      visit("/login")
      stub_andelan
      stub_current_session
      visit("/")
      expect(page).to have_content("Home")
      clear_session
    end

    scenario "Redirect no-registered learners to the login page" do
      visit("/login")
      stub_non_andelan
      visit("/")
      expect(page).to have_current_path(login_path)
    end

    scenario "Redirect registered learners to the leaners page" do
      visit("/login")
      stub_non_andelan_bootcamper @bootcamper
      stub_current_session_bootcamper @bootcamper
      visit("/")
      expect(page).to have_current_path(learner_path)
    end

    scenario "Restrict learners' access to learner's page" do
      visit("/login")
      stub_non_andelan_bootcamper @bootcamper
      stub_current_session_bootcamper @bootcamper
      visit("/content_management")
      expect(page).to have_current_path(learner_path)
    end
  end

  feature "User logout" do
    scenario "Users should be able to logout" do
      stub_andelan
      stub_current_session
      visit("/")
      click_link("Duyile Oluwatomi")
      click_link("Logout")
      expect(page).to have_current_path(login_path)
      clear_session
    end
  end
end

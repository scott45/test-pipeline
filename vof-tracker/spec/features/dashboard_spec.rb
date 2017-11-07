require "rails_helper"
require "spec_helper"

describe "Dashboard test" do
  before do
    stub_andelan
    stub_current_session
    visit("/bootcampers")
    find("div.card-image.nigeria").click
    fill_in("city", with: "Lagos")
    fill_in("application_cycle", with: "23")
    attach_file(
      "file", "#{Rails.root}/spec/fixtures/example.xlsx", visible: false
    )
    click_button("Submit")
    click_link("See Uploaded Cycle")
  end

  feature "View Learners Dashboard" do
    scenario "user should see uploaded camper data on the dashboard" do
      visit("/")
      expect(page).to have_content("Chimamanda Adichie")
    end
  end

  feature "Search Learner" do
    scenario "user should be able to search learners by name" do
      visit("/")
      fill_in("search", with: "Wangari Maathai")
      find_field("search").native.send_key(:enter)
      expect(page).to have_content("Wangari Maathai")
    end

    scenario "user should be able to search learners by email" do
      visit("/")
      expect(page).to have_content("Home")
      fill_in("search", with: "wangari@example.com")
      find_field("search").native.send_key(:enter)
    end

    scenario "user should see no result found for invalid camper name" do
      visit("/")
      fill_in("search", with: "unknown user")
      find_field("search").native.send_key(:enter)
      expect(page).to have_content("No Results Found")
    end

    scenario "user should see no result found for invalid camper email" do
      visit("/")
      fill_in("search", with: "unknown@example.com")
      find_field("search").native.send_key(:enter)
      expect(page).to have_content("No Results Found")
      clear_session
    end
  end

  feature "Filter Learners" do
    scenario "user should be able to select filter data dropdown options" do
      visit("/")
      location = page.all("div.filter_camper")[0].click
      location.find("li:nth-of-type(2)").click
      wait_for_ajax
      cycle = page.all("div.filter_camper")[1].click
      cycle.find("li:nth-of-type(2)").click
      click_button("apply-filter")
      expect(page).to have_content("Wangari Maathai")
      expect(page).to have_content("Specioza Kazibwe")
      clear_session
    end
  end
end

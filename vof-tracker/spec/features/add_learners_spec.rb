require "rails_helper"
require "spec_helper"

describe "Add learners" do
  before do
    stub_andelan
    stub_current_session
    visit("/bootcampers")
    find("div.card-image.nairobi").click
    fill_in("city", with: "Nairobi")
    fill_in("application_cycle", with: "25")
  end

  feature "see uploaded cycle link" do
    scenario "user should see a link to uploaded cycle on add learners page" do
      attach_file(
        "file", "#{Rails.root}/spec/fixtures/example.xlsx", visible: false
      )
      click_button("Submit")
      expect(page).to have_link("See Uploaded Cycle")
    end
  end

  feature "view error message" do
    scenario "user should see the error message on add learners page" do
      attach_file(
        "file", "#{Rails.root}/spec/fixtures/bootcampers.xlsx", visible: false
      )
      click_button("Submit")
      expect(page).
        to have_content("Please ensure the following rows are filled")
    end
  end
end

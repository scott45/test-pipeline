require "rails_helper"
require "spec_helper"

describe "Profile page test" do
  before :all do
    @program = Program.first || create(:program)
    @bootcamper = create(:bootcamper, program: @program)
    @assessment = Assessment.first || create(:assessment_with_phases)
    @point = Point.first || create(:point, value: 0,
                                           context: "No output submitted")
    @metric = create(:metric, assessment: @assessment, point: @point)
  end

  after(:all) do
    Score.delete_all
    Bootcamper.delete_all
  end

  before do
    stub_andelan
    stub_current_session
    visit("/")
    camper_name = @bootcamper.first_name + " " + @bootcamper.last_name
    click_link(camper_name)
    sleep 2
  end

  feature "view learners profile" do
    scenario "user should see uploaded camper data on the profile" do
      camper_name = @bootcamper.first_name + " " + @bootcamper.last_name
      expect(page).to have_content(camper_name)
    end

    scenario "user should see campers cycle" do
      cycle = @bootcamper.cycle
      expect(page).to have_content(cycle)
    end

    scenario "user should see campers email" do
      email = @bootcamper.email
      expect(page).to have_content(email)
    end
  end

  feature "submit scores" do
    scenario "user should not be able to submit blank scores" do
      click_button("submit-scores")
      expect(page).to have_content("Score(s) cannot be blank")
    end

    scenario "user should be able to submit scores" do
      phase = page.all("div.scores-dropdown")[0].click
      phase.find("li:nth-of-type(1)").click
      sleep 4
      criteria = page.all("div.scores-dropdown")[1].click
      criteria.find("li:nth-of-type(1)").click
      sleep 4
      score_card = page.all("div.input-wrapper").first
      score_card.find("label").click
      click_button("submit-scores")
      expect(page).to have_content("Assessment(s) recorded")
    end
  end

  feature "score guide modal pops up" do
    scenario "user should be able to see scoring card info" do
      page.all("em.info-icon").first.click
      sleep 4
      expect(page).to have_content(@metric.point.value)
    end
  end

  feature "decision status" do
    scenario "it shows user's current status " do
      expect(page).to have_content("Decision 1: In Progress")
      expect(page).to have_content("Decision 2: Not Applicable")
    end
  end
end

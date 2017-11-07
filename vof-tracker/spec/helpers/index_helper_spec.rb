require "rails_helper"
require_relative "../support/shared_context/score_details"

RSpec.describe IndexHelper, type: :helper do
  include_context "score details"

  let(:bootcamper) { create :bootcamper }

  after(:all) do
    Bootcamper.delete_all
  end

  describe ".pagination_metadata" do
    context "when no result is found" do
      it "has a start count of zero" do
        pagination = pagination_metadata(1, 15, 0, 0)
        expect(pagination).to eq "Showing 0 to 0 of 0 entries"
      end
    end
    context "when result is found" do
      it "has a start count greater than zero" do
        pagination = pagination_metadata(1, 15, 15, 36)
        expect(pagination).to eq "Showing 1 to 15 of 36 entries"
      end
    end
  end

  describe ".page_rows" do
    context "when page is loaded" do
      it "populates dropdown with options 15,30,45,60" do
        expect(page_rows).to eq %w(15 30 45 60)
      end
    end
  end

  describe ".get_total_assessed" do
    context "when page is loaded" do
      it "displays learner's total assessed assessment" do
        week1_assessments.each do |assessment|
          Score.save_score(
            {
              score: 2.0,
              phase_id: phases[0].id,
              assessment_id: assessment[:id]
            },
            bootcamper.camper_id
          )
        end
        total_assessed = get_total_assessed(bootcamper.camper_id)
        expect(total_assessed).to eql(4)
      end
    end
  end

  describe ".get_total_assessments" do
    context "when page is loaded" do
      it "displays total assessments" do
        total_assessments = get_total_assessments
        expect(total_assessments).to eql(58)
      end
    end
  end

  describe ".get_total_percentage" do
    context "when page is loaded" do
      it "displays learner's total percentage of 6.9" do
        total_percentage = get_total_percentage(4, 58)
        expect(total_percentage).to eql(6.9)
      end
    end
  end

  describe ".get_progress_status" do
    context "when page is loaded" do
      it "displays leaner's progress status of below-average" do
        progress_status = get_progress_status(6.9)
        expect(progress_status).to eql("below-average")
      end
    end
  end
end

RSpec.configure do |config|
  config.before(:suite) do
    Rails.application.load_seed # loading seeds
  end
end

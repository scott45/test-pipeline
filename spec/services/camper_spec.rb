require "rails_helper"

RSpec.describe CamperDataService do
  before(:all) do
    @bootcamper = create(:bootcamper)
    @camper_data = CamperDataService.get_camper_data(1, @bootcamper)
  end

  describe ".get_camper_data" do
    context "when downloading learners csv" do
      it "creates a row with the correct number of columns" do
        expect(@camper_data.size).to eq 21
      end

      it "creates a column with the camper's week one decision" do
        expect(@camper_data[8]).to eq @bootcamper.decision_one
      end

      it "creates a column with a reason for the camper's week one decision" do
        decision_one_reasons = CamperDataService.
                               format_decision_reasons(@bootcamper, 1)
        expect(@camper_data[9]).to eq decision_one_reasons
      end

      it "creates a column with comments on the camper's week one decision" do
        expect(@camper_data[10]).to eq @bootcamper.decision_one_comment
      end

      it "creates a column with the camper's week two decision" do
        expect(@camper_data[11]).to eq @bootcamper.decision_two
      end

      it "creates a column with a reason for the camper's week two decision" do
        decision_two_reasons = CamperDataService.
                               format_decision_reasons(@bootcamper, 2)
        expect(@camper_data[12]).to eq decision_two_reasons
      end

      it "creates a column with comments on the camper's week two decision" do
        expect(@camper_data[13]).to eq @bootcamper.decision_two_comment
      end

      it "creates a column with the overall average" do
        expect(@camper_data[14]).to eq @bootcamper.overall_average
      end

      it "creates a column with the week one average" do
        expect(@camper_data[15]).to eq @bootcamper.week1_average
      end

      it "creates a column with the week two average" do
        expect(@camper_data[16]).to eq @bootcamper.week2_average
      end

      it "creates a column with the project average" do
        expect(@camper_data[17]).to eq @bootcamper.project_average
      end

      it "creates a column with the values average" do
        expect(@camper_data[18]).to eq @bootcamper.value_average
      end

      it "creates a column with output average" do
        expect(@camper_data[19]).to eq @bootcamper.output_average
      end

      it "creates a column with feedback one average" do
        expect(@camper_data[20]).to eq @bootcamper.feedback_average
      end
    end
  end

  describe ".get_camper_score" do
    before(:all) do
      first_column = AssessmentService.get_assessment_json.first.second.first
      assessment = Assessment.find_or_create_by(name: first_column)
      create(
        :score,
        camper_id: @bootcamper.camper_id,
        score: 3,
        assessment: assessment
      )
      @camper_score = CamperDataService.get_camper_score(@bootcamper)
    end

    context "when downloading learners csv" do
      it"returns the bootcamper's assessments scores" do
        expect(@camper_score.size).to eq 58
      end

      it"returns the score for scored assessment" do
        expect(@camper_score.first).to eq 3
      end

      it"returns the score for scored assessment" do
        expect(@camper_score.last).to eq "-"
      end
    end
  end
end

RSpec.configure do |config|
  config.before(:suite) do
    Rails.application.load_seed
  end
end

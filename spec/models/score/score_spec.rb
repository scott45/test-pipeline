require "rails_helper"
require_relative "../../support/shared_context/score_details"

RSpec.describe Score, type: :model do
  include_context "score details"

  let(:bootcamper) { create :bootcamper }

  after(:all) do
    Bootcamper.delete_all
  end

  describe "Score Associations" do
    it { is_expected.to belong_to(:bootcamper) }
    it { is_expected.to belong_to(:assessment) }
    it { is_expected.to belong_to(:phase) }
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:score) }
    it { is_expected.to validate_presence_of(:phase_id) }
    it { is_expected.to validate_presence_of(:assessment_id) }
  end

  describe ".current_week" do
    it "returns week '2' for 'Project Assessment' phase" do
      phase = "Project Assessment"
      expect(Score.current_week(phase)).to eq "2"
    end

    it "returns week '2' for 'Bootcamp' phase" do
      phase = "Bootcamp"
      expect(Score.current_week(phase)).to eq "2"
    end

    it "returns week '1' for 'Home Session Day 1' phase" do
      phase = "Home Session Day 1"
      expect(Score.current_week(phase)).to eq "1"
    end

    it "returns week '1' for 'Home Session Day 3' phase" do
      phase = "Home Session Day 3"
      expect(Score.current_week(phase)).to eq "1"
    end
  end

  describe ".week_one_total_assessed" do
    context "when camper has not been scored for week 2" do
      it "returns 0 as week two total scored assessments" do
        expect(Score.week_one_total_assessed(bootcamper.camper_id)).to eql(0)
      end
    end

    context "when camper has been scored" do
      it "returns week one total scored assessments" do
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

        expect(Score.week_one_total_assessed(bootcamper.camper_id)).to eql(4)
      end
    end

    it "returns an integer" do
      total_assessed = Score.week_one_total_assessed(bootcamper.camper_id)
      expect(total_assessed).to be_a(Integer)
    end
  end

  describe ".week_two_total_assessed" do
    context "when camper has not been scored for week 1" do
      it "returns 0 as week two total scored assessments " do
        expect(Score.week_two_total_assessed(bootcamper.camper_id)).to eql(0)
      end
    end

    context "when camper has been scored" do
      it "returns week two total scored assessments" do
        week2_assessments.each do |assessment|
          Score.save_score(
            {
              score: 2.0,
              phase_id: phases[1].id,
              assessment_id: assessment[:id]
            },
            bootcamper.camper_id
          )
        end

        expect(Score.week_two_total_assessed(bootcamper.camper_id)).to eql(3)
      end
    end

    it "returns an integer" do
      total_assessed = Score.week_two_total_assessed(bootcamper.camper_id)
      expect(total_assessed).to be_a(Integer)
    end
  end

  describe ".get_bootcamper_scores" do
    context "when camper has not been scored" do
      it "returns no scores" do
        camper_scores = Score.get_bootcamper_scores(bootcamper.camper_id)
        expect(camper_scores.length).to eql(0)
      end
    end

    context "when camper has been scored" do
      it "returns all camper's scores" do
        week1_assessments.each do |assessment|
          params = {
            score: 2.0,
            phase_id: phases[0].id,
            assessment_id: assessment[:id]
          }
          Score.save_score(params, bootcamper.camper_id)
        end

        camper_scores = Score.get_bootcamper_scores(bootcamper.camper_id)

        expect(camper_scores.length).to eql(4)
      end
    end

    it "returns an array of active record" do
      camper_scores = Score.get_bootcamper_scores(bootcamper.camper_id)
      expect(camper_scores).to be_a(ActiveRecord::Relation)
    end
  end
end

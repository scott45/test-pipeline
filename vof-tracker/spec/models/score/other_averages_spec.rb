require "rails_helper"
require_relative "../../support/shared_context/score_details"

RSpec.describe Score, type: :model do
  include_context "score details"

  let(:bootcamper) { create :bootcamper }

  after(:all) do
    Bootcamper.delete_all
  end

  describe ".week_one_average" do
    context "when camper has not been scored" do
      it "returns 0.0 as week one average" do
        expect(Score.week_one_average(bootcamper.camper_id)).to eql(0.0)
      end
    end

    it "returns an average for week 1 scores" do
      week1_assessments.each do |assessment|
        Score.save_score(
          {
            score: 1.0,
            phase_id: phases[0].id,
            assessment_id: assessment[:id]
          },
          bootcamper.camper_id
        )
      end

      expect(Score.week_one_average(bootcamper.camper_id)).to eql(0.1)
    end

    it "returns a number" do
      expect(Score.week_one_average(bootcamper.camper_id)).to be_a(Numeric)
    end
  end

  describe ".week_two_average" do
    context "when camper has not been scored" do
      it "returns 0.0 as week two average" do
        expect(Score.week_two_average(bootcamper.camper_id)).to eql(0.0)
      end
    end

    context "when camper has been scored" do
      it "returns an average for week 2 scores" do
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

        expect(Score.week_two_average(bootcamper.camper_id)).to eql(0.4)
      end
    end

    it "returns a number" do
      expect(Score.week_two_average(bootcamper.camper_id)).to be_a(Numeric)
    end
  end

  describe ".final_project_average" do
    let!(:final_phase) { Phase.where(name: "Project Assessment") }

    context "when camper has not been scored" do
      it "returns 0.0 as overall average" do
        expect(Score.final_project_average(bootcamper.camper_id)).to eql(0.0)
      end
    end

    context "when camper has been scored" do
      it "returns final project average" do
        assessments = [
          { name: "Version Control" },
          { name: "Test-Driven Development" },
          { name: "Project Management" },
          { name: "Code Syntax Norms" }
        ]
        assessments.each do |assessment|
          Score.save_score(
            {
              score: 2.0,
              phase_id: final_phase[0][:id],
              assessment_id: Assessment.find_by_name(assessment[:name]).id
            },
            bootcamper.camper_id
          )
        end

        expect(Score.final_project_average(bootcamper.camper_id)).to eql(1.3)
      end
    end

    it "returns a number" do
      expect(Score.final_project_average(bootcamper.camper_id)).to be_a(Numeric)
    end
  end

  describe ".overall_average" do
    context "when camper has not been scored" do
      it "returns 0.0 as overall average" do
        expect(Score.overall_average(bootcamper.camper_id)).to eql(0.0)
      end
    end

    context "when camper has been scored" do
      it "returns camper's overall average" do
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

        week2_assessments.each do |assessment|
          Score.save_score(
            {
              score: 2.0,
              phase_id: phases[0].id,
              assessment_id: assessment[:id]
            },
            bootcamper.camper_id
          )
        end

        expect(Score.overall_average(bootcamper.camper_id)).to eql(2.0)
      end
    end

    it "returns a number" do
      expect(Score.overall_average(bootcamper.camper_id)).to be_a(Numeric)
    end
  end
end

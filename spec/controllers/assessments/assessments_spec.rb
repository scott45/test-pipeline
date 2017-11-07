require "rails_helper"

RSpec.describe AssessmentsController, type: :controller do
  let(:user) { create :user }
  let(:json) { response.body }
  let(:phase) { create :phase }
  let!(:framework_criterium) { create :framework_criterium }
  let(:bootcamper) { create :bootcamper }

  let!(:assessment) do
    create :assessment,
           name: "Writing professionally",
           phases: [phase],
           framework_criterium: framework_criterium,
           description: "A medium blog post",
           context: "This is a context"
  end

  let!(:metric) do
    create :metric,
           description: "Improves on Feedback Given",
           point: Point.first,
           assessment_id: assessment.id
  end

  let!(:score) do
    create :score,
           camper_id: bootcamper.camper_id,
           assessment_id: assessment.id,
           phase_id: phase.id
  end

  before do
    stub_current_user(:user)
    controller.stub(:admin?)
  end

  describe "GET #all" do
    context "when there is a phase" do
      let(:response) do
        get :all, params: { id: bootcamper.id, phase_id: phase.id }
      end

      it "returns a 200 status" do
        expect(response).to have_http_status 200
      end

      it "gets all the assessments in JSON" do
        result = {
          framework_criterium.framework[:name] => {
            framework_criterium.framework.criteria[0][:name] => [assessment]
          }
        }.to_json

        expect(response.body).to eq result
      end
    end

    context "when there is invalid phase" do
      let(:response) do
        get :all, params: { id: bootcamper.id, phase_id: "invalid" }
      end

      it "returns a 404 status" do
        expect(response).to have_http_status 404
      end

      it "returns a 'not found' message" do
        expect(response.body).to eq "404 Not Found"
      end
    end

    context "when a non-admin attempts to get all outputs" do
      it_behaves_like "prevent non admins from performing CRUD"
    end
  end

  describe "GET #get_completed_assessments" do
    context "when bootcamper exist" do
      it "renders completed assessment for a particular bootcamper" do
        get :get_completed_assessments, params: { id: bootcamper.id }
        expect(response.content_type).to eq Mime[:json]
      end
    end

    context "when bootcamper does not exist" do
      it "raises an error when there is no bootcamper" do
        expect do
          get :get_completed_assessments, params: { id: nil }
        end.to raise_error ActionController::UrlGenerationError
      end
    end
  end

  describe "GET #get_assessment_metrics" do
    context "when an assessment exists" do
      let(:assessment_data) do
        get :get_assessment_metrics,
            params: { id: assessment.id }
      end

      it "returns the appropriate description" do
        expect(assessment_data.body).to include(assessment.description)
      end

      it "returns the appropriate context" do
        expect(assessment_data.body).to include(assessment.context)
      end

      it "returns the appropriate metrics" do
        expect(assessment_data.body).to include(metric.description)
      end

      it "renders context and metrics for an assessment" do
        expect(assessment_data.content_type).to eq Mime[:json]
      end
    end

    context "when an assessment does not exist" do
      it "raises an error" do
        expect do
          get :get_assessment_metrics, params: { id: nil }
        end.to raise_error ActionController::UrlGenerationError
      end
    end
  end

  describe "GET #get_framework_criteria" do
    let(:json) { JSON.parse(response.body) }

    before(:each) do
      allow(controller).to receive_message_chain(
        "helpers.admin?"
      ).and_return true

      get :get_framework_criteria
    end

    it "returns a json with a count of 3" do
      expect(json.count).to eq 5
    end

    it "returns all frameworks" do
      expect(json).to include "frameworks"
      expect(json).to include "assessments"
      expect(json).to include "criterium_frameworks"
    end

    it "returns the appropriate user role" do
      expect(json["is_admin"]).to eq true
    end
  end
end

require "rails_helper"

RSpec.describe AssessmentsController, type: :controller do
  let(:user) { create :user }
  let(:framework_criterium) { create :framework_criterium }
  let(:json) { JSON.parse(response.body) }
  let!(:assessment) do
    create :assessment,
           name: "Writing professionally",
           context: "A medium blog post",
           description: "Simple description",
           framework_criterium_id: framework_criterium.id
  end

  let(:points) { Point.all }

  before do
    stub_current_user(:user)
    controller.stub(:admin?)
    points.map { |point| create(:metric, point: point, assessment: assessment) }
  end

  describe "PUT #update" do
    context "when an admin successfully updates an output" do
      it "displays a successful flash message" do
        put :update, format: :js, params: {
          id: assessment.id,
          assessment: {
            name: "This assessment names is updated",
            description: "This description is updated",
            context: "This context is updated",
            metrics_attributes: [{
              id: assessment.metrics.first.id,
              description: "metric description updated",
              point_id: assessment.metrics.first.point.id
            }]
          }
        }
        expect(flash[:notice]).to eq "update-success"
      end
    end

    context "when an admin leaves an output field blank " do
      it "displays an error flash message" do
        put :update, format: :js, params: {
          id: assessment.id,
          assessment: {
            name: "This assessment names is updated",
            description: "This description is updated",
            context: "This context is updated",
            metrics_attributes: [{
              id: assessment.metrics.first.id,
              description: "",
              point_id: assessment.metrics.first.point.id
            }]
          }
        }
        expect(flash[:error]).to eq "Metrics description can't be blank"
      end
    end

    context "when a non-admin attempts to update an output" do
      it_behaves_like "prevent non admins from performing CRUD"
    end
  end
end

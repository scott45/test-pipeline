require "rails_helper"

RSpec.describe AssessmentsController, type: :controller do
  let(:user) { create :user }
  let(:assessment_params) do
    attributes_for(
      :assessment,
      framework_criterium_id: create(:framework_criterium).id,
      metrics_attributes:
        Point.all.map do |point|
          attributes_for(:metric, point_id: point.id)
        end
    )
  end
  let(:point) { create_list(:point, 4) }
  before do
    stub_current_user(:user)
    controller.stub(:admin?)
  end

  describe "POST #create" do
    context "when output saves successfully" do
      it "creates a new output" do
        expect do
          post :create, params: { assessment: assessment_params }, xhr: true
        end.to change(Assessment, :count).by(1)
      end

      it "creates four new metrics" do
        expect do
          post :create, params: { assessment: assessment_params }, xhr: true
        end.to change(Metric, :count).by(4)
      end

      it "displays a successful flash message" do
        post :create, params: { assessment: assessment_params }, xhr: true
        expect(flash[:notice]).to eq "assessment-success"
      end
    end

    context "when output does not save successfully" do
      it "does not create a new output" do
        expect do
          post :create, params: { assessment: attributes_for(
            :assessment,
            framework_criterium_id: "",
            metrics_attributes: ""
          ) }, xhr: true
        end.not_to change(Assessment, :count)
      end

      it "does not create any metrics" do
        expect do
          post :create, params: { assessment: attributes_for(
            :assessment,
            framework_criterium_id: "",
            metrics_attributes: ""
          ) }, xhr: true
        end.not_to change(Metric, :count)
      end
    end

    context "when an assessment name already exists" do
      it "displays an appropriate flash message" do
        post :create, params: { assessment: assessment_params }, xhr: true
        post :create, params: { assessment: assessment_params }, xhr: true
        expect(flash[:error]).to eq "Name has already been taken"
      end
    end

    context "when a non-admin attempts to create an output" do
      it_behaves_like "prevent non admins from performing CRUD"
    end
  end
end

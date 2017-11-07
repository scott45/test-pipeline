require "rails_helper"

RSpec.describe AssessmentsController, type: :controller do
  let(:user) { create :user }
  let(:assessments) { create :assessment }
  let(:json) { JSON.parse(response.body) }

  before do
    stub_current_user(:user)
    controller.stub(:admin?)
    get :show, params: { id: assessments.id }
  end

  describe "GET #show" do
    context "when getting an assessment and all its attributes " do
      it "responds in json format" do
        expect(response.content_type).to eq "application/json"
      end
    end

    context "when a non-admin attempts to perfrom show action of an output" do
      it_behaves_like "prevent non admins from performing CRUD"
    end
  end
end

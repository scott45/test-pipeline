require "rails_helper"

RSpec.describe AssessmentsController, type: :controller do
  let(:user) { create :user }
  before do
    stub_current_user(:user)
    controller.stub(:admin?)
  end

  let(:params) do
    {
      criterium: attributes_for(:criterium),
      frameworks: [create(:framework).id]
    }
  end

  describe "GET #get_framework_criteria" do
    let(:json) { JSON.parse(response.body) }

    before(:each) do
      allow(controller).to receive_message_chain(
        "helpers.admin?"
      ).and_return true

      get :get_framework_criteria
    end

    it "returns a json with a count of 5" do
      expect(json.count).to eq 5
    end

    it "returns all criteria and frameworks" do
      expect(json).to include "frameworks"
      expect(json).to include "criteria"
    end

    it "returns the appropriate user role" do
      expect(json["is_admin"]).to eq true
    end
  end
end

require "rails_helper"

RSpec.describe DecisionReasonController, type: :controller do
  let(:user) { create :user }
  let!(:bootcamper) { create :bootcamper }
  describe "GET #get_status_reasons" do
    before do
      stub_current_user(:user)
    end

    context "when given a valid decision status" do
      it "renders the possible reasons as json" do
        get :get_status_reasons,
            params: {
              status: "In Progress",
              stage: 1,
              id: bootcamper.camper_id
            }
        expect(response.body).to_json
      end
    end
  end
end

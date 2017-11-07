require "rails_helper"

RSpec.describe BootcampersController, type: :controller do
  let(:user) { create :user }
  let!(:bootcamper) { create :bootcamper }
  let(:params) do
    { id: bootcamper.id,
      decision_stage_reasons: { 1 => ["Integrity Issues"] }, }
  end

  before do
    stub_current_user(:user)
  end

  describe "PUT #save_decision_reasons" do
    context "when updating a decision reason" do
      it "responds with a json" do
        allow_any_instance_of(ApplicationHelper).
          to receive(:admin?).and_return(true)

        allow_any_instance_of(ApplicationHelper).
          to receive(:user_is_lfa?).and_return(false)

        put :save_decision_comments,
            params: params,
            xhr: true
        expect(response.body).to_json
      end
    end
  end
end

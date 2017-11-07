require "rails_helper"
require "spec_helper"

RSpec.describe BootcampersController, type: :controller do
  let(:user) { create :user }
  let!(:bootcamper) { create :bootcamper }
  let(:params) do
    {
      id: bootcamper.id,
      decision_one_comment: "The only good decision",
      decision_two_comment: "The second good decision"
    }
  end

  before do
    stub_current_user(:user)
  end

  after(:all) do
    Bootcamper.delete_all
  end

  describe "PUT #save_decision_comments" do
    context "when user is camper's lfa" do
      it "updates decision comments" do
        allow_any_instance_of(ApplicationHelper).
          to receive(:user_is_lfa?).and_return(true)

        put :save_decision_comments,
            params: params,
            xhr: true

        bootcamper.reload
        expect(bootcamper.decision_one_comment).
          to eq params[:decision_one_comment]

        expect(bootcamper.decision_two_comment).
          to eq params[:decision_two_comment]

        expect(flash[:notice]).to eq "decision-comments-success"
      end
    end

    context "when user is an admin" do
      it "updates decision comments" do
        allow_any_instance_of(ApplicationHelper).
          to receive(:admin?).and_return(true)

        allow_any_instance_of(ApplicationHelper).
          to receive(:user_is_lfa?).and_return(false)

        put :save_decision_comments,
            params: params,
            xhr: true

        bootcamper.reload
        expect(bootcamper.decision_one_comment).
          to eq params[:decision_one_comment]

        expect(bootcamper.decision_two_comment).
          to eq params[:decision_two_comment]

        expect(flash[:notice]).to eq "decision-comments-success"
      end
    end

    context "when user is not the camper's lfa and not an admin" do
      it "does not update decision comments" do
        allow_any_instance_of(ApplicationHelper).
          to receive(:user_is_lfa?).and_return(false)

        allow_any_instance_of(ApplicationHelper).
          to receive(:admin?).and_return(false)

        params[:decision_two_comment] = "This is one"
        put :save_decision_comments,
            params: params,
            xhr: true

        bootcamper.reload
        expect(bootcamper.decision_two_comment).not_to eq "This is one"
      end
    end
  end
end

require "rails_helper"

RSpec.describe BootcampersController, type: :controller do
  let(:user) { create :user }
  let(:bootcamper) { create :bootcamper }
  let(:json) { JSON.parse(response.body) }

  describe "PUT #update" do
    before do
      stub_current_user(:user)
    end

    describe "an admin user" do
      before(:each) do
        allow(controller).to receive_message_chain(:helpers, :admin?).
          and_return true
      end

      context "when decision1 is advanced" do
        it "updates decision2 status to in progress" do
          put :update, params: { id: bootcamper.id,
                                 decision_one: "Advanced",
                                 format: :json }
          bootcamper.reload
          expect(bootcamper.decision_one).to eq "Advanced"
          expect(bootcamper.decision_two).to eq "In Progress"
        end
      end

      context "when decision1 is in progress" do
        it "updates decision2 status to not applicable" do
          put :update, params: { id: bootcamper.id,
                                 decision_one: "In Progress",
                                 format: :json }
          bootcamper.reload
          expect(bootcamper.decision_one).to eq "In Progress"
          expect(bootcamper.decision_two).to eq "Not Applicable"
        end
      end

      context "when decision1 status is in progress" do
        it "updates week2 lfa to unassigned" do
          put :update, params: { id: bootcamper.id,
                                 decision_one: "In Progress",
                                 format: :json }
          bootcamper.reload
          expect(bootcamper.decision_one).to eq "In Progress"
          expect(bootcamper.week_two_lfa).to eq "Unassigned"
        end
      end

      it "returns message after successful update" do
        put :update, params: { id: bootcamper.id,
                               decision_one: "Advanced",
                               format: :json }
        expect(json["message"]).to eq "status update successful"
      end

      context "when decision1 is accepted" do
        it "updates decision2 status to not applicable" do
          put :update, params: { id: bootcamper.id,
                                 decision_one: "Accepted",
                                 format: :json }
          bootcamper.reload
          expect(bootcamper.decision_one).to eq "Accepted"
          expect(bootcamper.decision_two).to eq "Not Applicable"
        end
      end
    end

    describe "for a non admin user" do
      before(:each) do
        allow(controller).to receive_message_chain(:helpers, :admin?).
          and_return false
      end

      it "allows non admin user" do
        put :update, params: { id: bootcamper.id, decision_one: "Advanced" }
        expect(response.body).to eq ""
      end
    end
  end
end

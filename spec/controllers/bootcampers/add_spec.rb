require "rails_helper"

RSpec.describe BootcampersController, type: :controller do
  let(:user) { create :user }

  describe "POST #add" do
    before do
      stub_current_user(:user)
    end

    context "when spreadsheet is valid" do
      let(:doc) do
        fixture_file_upload("bootcampers.xlsx", "application/vnd.ms-excel")
      end

      it "uploads valid bootcampers" do
        post :add, params: { country: "Nigeria",
                             city: "Lagos",
                             cycle: 22,
                             file: doc }
        expect(response).to render_template(:index)
      end
    end

    context "when spreadsheet is invalid" do
      let(:doc) do
        fixture_file_upload("invalid.xlsx", "application/vnd.ms-excel")
      end

      it "displays error message" do
        post :add, params: { country: "Nigeria",
                             city: "Lagos",
                             cycle: 22,
                             file: doc }
        expect(assigns[:error]).to be_truthy
      end
    end

    context "when spreadsheet contains duplicate email address" do
      let(:doc) do
        fixture_file_upload("duplicates.xlsx", "application/vnd.ms-excel")
      end

      it "displays error message" do
        post :add, params: { country: "Nigeria",
                             city: "Lagos",
                             cycle: 22,
                             file: doc }
        expect(assigns[:error]).to be_truthy
      end
    end
  end
end

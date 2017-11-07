require "rails_helper"

RSpec.describe ScoresController, type: :controller do
  let(:user) { create :user }
  let(:bootcamper) { create :bootcamper }
  let!(:framework_criterium) { create :framework_criterium }
  let!(:assessment) do
    create :assessment,
           name: "Writing professionally",
           phases: [phase],
           framework_criterium: framework_criterium,
           context: "Medium Post",
           description: "Simple description"
  end
  let!(:phase) { Phase.create(name: "Learning Clinic") }

  before do
    stub_current_user(:user)
    get :new, params: { id: 1 }
  end

  describe "GET #new" do
    it "renders the profile template" do
      expect(response).to render_template("profile/profile")
    end

    it "returns a success status code" do
      expect(response).to be_success
    end
  end
end

require "rails_helper"
RSpec.describe ContentManagementController, type: :controller do
  let(:user) { create :user }

  describe "GET #index" do
    before do
      stub_current_user(:user)
      get :index
    end

    it "loads frameworks" do
      expect(assigns[:content][:frameworks]).to be_truthy
      expect(assigns[:content][:framework]).to be_truthy
    end

    it "loads criteria" do
      expect(assigns[:content][:criteria]).to be_truthy
      expect(assigns[:content][:criterium]).to be_truthy
    end

    it "loads assessments" do
      expect(assigns[:content][:assessments]).to be_truthy
      expect(assigns[:content][:assessment]).to be_truthy
    end

    it "builds metrics for new assessment" do
      expect(assigns[:content][:assessment].metrics.length).to eq 4
    end
  end
end

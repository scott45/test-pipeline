require "rails_helper"

RSpec.describe BootcampersController, type: :controller do
  render_views
  let(:user) { create :user }
  let(:json) { JSON.parse(response.body) }
  let!(:bootcampers) { create_list(:bootcamper, 4) }

  before do
    stub_current_user(:user)
  end

  let(:response) do
    get :all
  end

  describe "GET #all" do
    it "returns success" do
      expect(response).to be_success
    end

    it "returns bootcampers with the count of 4  " do
      expect(json.count).to eq 4
    end

    it "returns a json " do
      expect(response.content_type).to eq "application/json"
    end
  end
end

require "rails_helper"

RSpec.describe PhasesController, type: :controller do
  let(:user) { create :user }
  let(:json) { JSON.parse(response.body) }

  before(:all) do
    @camper = create :bootcamper do |camper|
      create :phase, program: camper.program do
        create :phase, name: "Home Session 1", program: camper.program
      end
    end
  end

  after(:all) do
    @camper.destroy
  end

  before do
    stub_current_user(:user)
    get :program_phases, params: { id: @camper.camper_id }
  end

  describe "GET #program_phases" do
    it "returns success" do
      expect(response).to be_success
    end

    it "returns a json with a count of 2" do
      expect(json.count).to eq 2
    end

    it "returns learning clinic as first phase" do
      expect(json[0]["name"]).to eq "Learning Clinic"
    end

    it "returns home session 1 as second phase" do
      expect(json[1]["name"]).to eq "Home Session 1"
    end

    it "renders a json response with all the phases" do
      expect(json[0]["name"]).to eq "Learning Clinic"
      expect(json[1]["name"]).to eq "Home Session 1"
    end
  end
end

require "rails_helper"

RSpec.describe SearchController, type: :controller do
  let(:user) { create :user }
  let(:json) { JSON.parse(response.body) }
  let!(:bootcamper) do
    create(
      :bootcamper,
      first_name: "Awafuname",
      last_name: "Awaluname",
      email: "awafunama@email.com"
    )
  end

  describe "GET #autocomplete" do
    before do
      stub_current_user(:user)
      get :autocomplete
    end

    it "returns success" do
      expect(response).to be_success
    end

    it "returns a json " do
      expect(response.content_type).to eq "application/json"
    end

    it "returns json response with an email" do
      expect(json[0]).to eq "awafunama@email.com"
    end

    it "returns json response with fullname" do
      expect(json[1]).to eq "Awafuname Awaluname"
    end
  end
end

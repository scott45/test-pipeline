require "rails_helper"

RSpec.describe LearnersController, type: :controller do
  let!(:bootcamper) { create :bootcamper }

  describe "GET #index" do
    before do
      stub_current_user(:bootcamper)
      get :index
    end

    context "when format is html" do
      it "renders index template" do
        expect(response).to render_template(:index)
      end

      it "responds to html format" do
        expect(response.content_type).to eq Mime[:html]
      end
    end
  end
end

require "rails_helper"

RSpec.describe IndexController, type: :controller do
  let(:user) { create :user }
  let!(:bootcamper) { create :bootcamper }
  let!(:bootcamper2) { create :bootcamper }

  describe "GET #index" do
    before do
      stub_current_user(:user)
      get :index, params: { city: "All",
                            cycle: "All",
                            week_one_lfa: "All",
                            week_two_lfa: "All",
                            decision_one: "All",
                            decision_two: "All",
                            page: 1,
                            num_pages: 3,
                            page_size: 15 }
    end

    context "when format is html" do
      it "renders index template" do
        expect(response).to render_template(:index)
      end

      it "responds to html format" do
        expect(response.content_type).to eq Mime[:html]
      end
    end

    context "when the template is rendered" do
      it "contains the dashboard instance variable" do
        expect(assigns(:dashboard)).to_not eq nil
      end
      it "returns the campers instance variable" do
        expect(assigns(:campers)).to_not eq nil
      end
    end

    context "when dashboard is populated " do
      it "sorts campers by most recent" do
        expect(assigns(:campers)[0]["camper_id"]).to eq bootcamper2.camper_id
      end
    end

    context "when format is csv" do
      let(:csv_filename) { { filename: "bootcampers-#{Date.today}.csv" } }
      let(:csv_header_1) do
        BootcampersCsvService.generate_report(
          city: "All",
          cycle: "All",
          week_one_lfa: "All",
          week_two_lfa: "All",
          decision_one: "Advanced",
          decision_two: "All"
        )
      end

      before do
        stub_allow_admin
        stub_export_csv
        get :index, format: :csv
      end

      it "has access to the send_data method" do
        expect(controller).to receive(:send_data).
          with(csv_filename, csv_header_1)
        controller.send_data(csv_filename, csv_header_1)
      end

      it "returns text/csv headers" do
        expect(response.headers["Content-Type"]).to include "text/csv"
      end

      it "returns gender column in the csv file" do
        expect(response.body).to include "Gender"
      end
    end
  end
end

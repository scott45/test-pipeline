require "rails_helper"

RSpec.describe CriteriaController, type: :controller do
  let(:user) { create :user }
  let(:criterium) { create :criterium }
  let(:json) { JSON.parse(response.body) }

  before(:all) do
    @framework = create(:framework)
    @another_framework = create(:framework)
  end

  before do
    stub_current_user(:user)
    controller.stub(:admin?)
  end

  describe "PUT #update" do
    context "when an admin inputs appropriate criterion fields" do
      it "flashes a success message" do
        put :update, params: {
          id: criterium.id,
          criterium: attributes_for(
            :criterium,
            name: "update this",
            description: "updated it"
          ),
          frameworks: [@framework.id]
        }, xhr: true
        expect(flash[:notice]).to eq "update-success"
      end
    end

    context "when an admin leaves the name or description input fields empty" do
      it "flashes a error message" do
        put :update, params: {
          id: criterium.id,
          criterium: attributes_for(
            :criterium,
            name: "",
            description: "something described"
          ),
          frameworks: [@framework.id]
        }, xhr: true
        expect(flash[:error]).to eq "Name can't be blank"
      end

      it "flashes a error message" do
        put :update, params: {
          id: criterium.id,
          criterium: attributes_for(
            :criterium,
            name: "something named",
            description: ""
          ),
          frameworks: [@framework.id]
        }, xhr: true
        expect(flash[:error]).to eq "Description can't be blank"
      end
    end

    context "when an admin enters a name value that already exists" do
      it "flashes a error message" do
        post :create, params: {
          criterium: attributes_for(
            :criterium,
            name: "Skills",
            description: "Measure skills"
          ),
          frameworks: [@framework.id]
        }, xhr: true
        put :update, params: {
          id: criterium.id,
          criterium: attributes_for(
            :criterium,
            name: "Skills",
            description: "something familiar"
          ),
          frameworks: [@framework.id]
        }, xhr: true
        expect(flash[:error]).to eq "Name has already been taken"
      end
    end

    context "when admin does not select a framework" do
      it "displays appropriate flash message" do
        put :update, params: {
          id: criterium.id,
          criterium: attributes_for(
            :criterium,
            name: "Something cool",
            description: "Measures something cool"
          )
        }, xhr: true
        expect(flash[:error]).to eq "Please select at least one framework"
      end
    end

    context "when a non-admin attempts to view actions" do
      it "displays content management page with no actions" do
        controller.stub(admin?: false)
        expect do
          redirect_to content_management_path
        end
      end
    end
  end
end

require "rails_helper"

RSpec.describe BootcampersController, type: :controller do
  let(:user) { create :user }

  describe "GET #edit" do
    it_behaves_like("response success", "get", :edit)
  end
end

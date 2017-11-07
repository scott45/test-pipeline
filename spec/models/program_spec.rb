require "rails_helper"

RSpec.describe Program, type: :model do
  describe "Program Associations" do
    it { is_expected.to have_many(:phases) }
  end
end

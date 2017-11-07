require "rails_helper"

RSpec.describe Phase, type: :model do
  describe "Phase Associations" do
    it { is_expected.to have_and_belong_to_many(:assessments) }
    it { is_expected.to have_many(:scores) }
    it { is_expected.to belong_to(:program) }
  end
end

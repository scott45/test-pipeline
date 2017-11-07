require "rails_helper"

RSpec.describe Criterium, type: :model do
  describe "Validations" do
    it { is_expected.to have_many(:frameworks).through(:framework_criteria) }
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end
end

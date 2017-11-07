require "rails_helper"

RSpec.describe Assessment, type: :model do
  context "when validating associations" do
    it { is_expected.to have_many(:scores) }
    it { is_expected.to belong_to(:framework_criterium) }
    it { is_expected.to have_and_belong_to_many(:phases) }
  end

  context "when validating fields" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_presence_of(:context) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:framework_criterium_id) }
  end
end

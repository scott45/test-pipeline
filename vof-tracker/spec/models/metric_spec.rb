require "rails_helper"

RSpec.describe Metric, type: :model do
  context "when validating associations" do
    it { is_expected.to belong_to(:point) }
    it { is_expected.to belong_to(:assessment) }
  end

  context "when validating fields" do
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:point_id) }
    it { is_expected.to validate_presence_of(:assessment) }
  end
end

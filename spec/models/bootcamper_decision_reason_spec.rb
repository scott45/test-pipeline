require "rails_helper"

RSpec.describe BootcamperDecisionReason, type: :model do
  context "when validating associations" do
    it { is_expected.to belong_to(:bootcamper) }
    it { is_expected.to belong_to(:decision_reason) }
  end

  context "when validating fields" do
    it { is_expected.to validate_presence_of(:camper_id) }
    it { is_expected.to validate_presence_of(:decision_stage) }
    it { is_expected.to validate_presence_of(:decision_reason_id) }
  end
end

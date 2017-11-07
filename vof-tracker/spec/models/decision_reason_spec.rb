require "rails_helper"

RSpec.describe DecisionReason, type: :model do
  context "when validating associations" do
    it { is_expected.to have_many(:bootcamper_decision_reasons) }
    it { is_expected.to have_many(:bootcampers) }
    it "has many decision statuses" do
      is_expected.to have_many(:decision_statuses).
        through(:decision_reason_statuses)
    end
  end

  context "when validating fields" do
    it { is_expected.to validate_presence_of(:reason) }
    it { is_expected.to validate_uniqueness_of(:reason).case_insensitive }
  end

  describe ".get_ids" do
    context "when given valid decision reasons" do
      it "returns the ids of the reasons" do
        reasons_id = DecisionReason.get_ids(["Values Alignment", "Commitment"])
        expect(reasons_id).to match_array([5, 9])
      end
    end

    context "when given invalid decision reasons" do
      it "returns nil" do
        expect(DecisionReason.get_ids(["Alignment"])).to be_nil
      end
    end
  end
end

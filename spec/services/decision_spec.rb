require "rails_helper"

RSpec.describe DecisionService do
  describe ".get_decision_data" do
    it "returns the decision data" do
      decision = DecisionService.new
      @decision_data = decision.get_decision_data
      expect(@decision_data.size).to eq 7
    end
  end
end

RSpec.configure do |config|
  config.before(:suite) do
    Rails.application.load_seed
  end
end

require "rails_helper"

describe ApplicationHelper, type: :helper do
  describe "#set_status_color" do
    let(:bootcamper) { create :bootcamper }

    context "when camper's week 1 status is rejected" do
      it "concatenates string 'status-' with week 1 status" do
        bootcamper.update(decision_one: "Rejected")
        status_color = set_status_color(bootcamper.decision_one)
        expect(status_color).to eq "status-rejected"
      end
    end

    context "when camper's week 2 status is accepted " do
      it "concatenates string 'status-' with week 2 status" do
        bootcamper.update(decision_two: "Accepted")
        status_color = set_status_color(bootcamper.decision_two)
        expect(status_color).to eq "status-accepted"
      end
    end
  end
end

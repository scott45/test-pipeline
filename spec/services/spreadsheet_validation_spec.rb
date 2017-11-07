require "rails_helper"

RSpec.describe SpreadsheetService do
  let!(:bootcampers) { create_list(:bootcamper, 4) }
  let(:spreadsheet) { Class.new { extend SpreadsheetValidationService } }

  describe ".validate_email" do
    context "when adding learners" do
      it "returns duplicate email address" do
        bootcampers[0].email = bootcampers[1].email
        duplicate_email = spreadsheet.validate_email(bootcampers)
        expect(duplicate_email).not_to be_empty
      end

      it "returns no duplicate email address" do
        duplicate_email = spreadsheet.validate_email(bootcampers)
        expect(duplicate_email).to be_empty
      end
    end
  end
end

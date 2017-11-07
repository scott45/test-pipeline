require "rails_helper"

RSpec.describe Bootcamper, type: :model do
  context "when validating fields" do
    subject do
      Bootcamper.new(
        camper_id: Bootcamper.generate_camper_id
      )
    end

    it { is_expected.to validate_presence_of(:camper_id) }
    it { is_expected.to validate_uniqueness_of(:camper_id) }
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:week_one_lfa) }
    it { is_expected.to validate_presence_of(:country) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_presence_of(:cycle) }
    it { is_expected.to validate_presence_of(:gender) }
    it { is_expected.to validate_acceptance_of(:gender) }
    it { should validate_uniqueness_of(:email).scoped_to(:cycle) }
  end

  context "when validating associations" do
    it { is_expected.to have_many(:scores) }
    it { is_expected.to have_many(:bootcamper_decision_reasons) }
    it { is_expected.to have_many(:decision_reasons) }
  end

  describe ".generate_camper_id" do
    context "when generating camper id" do
      it "returns a string" do
        expect(Bootcamper.generate_camper_id).to be_a(String)
      end

      it "returns a unique string" do
        first_camper_id = Bootcamper.generate_camper_id
        second_camper_id = Bootcamper.generate_camper_id

        expect(first_camper_id).not_to eq(second_camper_id)
      end
    end
  end

  describe ".update_campers_progress" do
    let(:bootcamper) { create :bootcamper }

    context "when creating a bootcamper" do
      it "has empty value for week1 progress" do
        expect(bootcamper.progress_week1).to be_nil
      end

      it "has empty value for week2 progress" do
        expect(bootcamper.progress_week2).to be_nil
      end
    end

    context "when given valid argument" do
      let(:bootcamper_data) do
        {
          id: bootcamper.camper_id,
          week1_score: 34,
          week1_total: 42,
          week2_score: 10,
          week2_total: 16
        }
      end

      before { create :phase, name: "Project Assessment" }

      it "updates a camper's week1 progress" do
        Bootcamper.update_campers_progress(bootcamper_data)
        updated_camper = Bootcamper.find_by(camper_id: bootcamper.camper_id)

        expect(updated_camper.progress_week1).to eq 80
      end

      it "updates a camper's week2 progress" do
        Bootcamper.update_campers_progress(bootcamper_data)
        updated_camper = Bootcamper.find_by(camper_id: bootcamper.camper_id)

        expect(updated_camper.progress_week2).to eq 62
      end
    end
  end

  describe ".search" do
    context "when results does not match search criteria" do
      it "returns empty result" do
        search_term = "8xeaa23422"
        expect(Bootcamper.search(search_term).length).to eq(0)
      end
    end

    context "when results match search criteria" do
      it "returns one camper that matches search criteria" do
        bootcamper = create(:bootcamper)
        search_term = bootcamper.email

        expect(Bootcamper.search(search_term).length).to eq(1)
      end

      it "returns all campers that match search criteria" do
        first_bootcamper = create(:bootcamper)
        create(
          :bootcamper,
          last_name: first_bootcamper.first_name
        )
        search_term = first_bootcamper.first_name

        expect(Bootcamper.search(search_term).length).to eq(2)
      end
    end
  end

  describe "#name" do
    context "when a camper has been created" do
      it "returns the camper's full name" do
        bootcamper = create(:bootcamper)

        expect(bootcamper.name).to eq(
          "#{bootcamper.first_name} #{bootcamper.last_name}"
        )
      end
    end
  end

  describe ".lfas" do
    context "when given non-existent location and/or cycle" do
      it "returns empty result" do
        expect(Bootcamper.lfas("Abuja", "10")).to be_empty
      end
    end

    context "when given valid location and cycle" do
      it "returns all week1 LFAs" do
        lfas = []
        5.times do
          lfas.push(
            create(:bootcamper, city: "Lagos", cycle: "10").week_one_lfa
          )
        end

        expect(Bootcamper.lfas("Lagos", "10")).to eq lfas
      end
    end
  end
end

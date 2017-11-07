FactoryGirl.define do
  factory :assessment do
    name "Communication"
    description "Simple description"
    context "versioning"
    framework_criterium
    factory :assessment_with_phases do
      after(:create) do |assessment|
        create(:phase, assessments: [assessment])
        create(:phase, name: "Project Assessment", assessments: [assessment])
      end
    end
  end
end

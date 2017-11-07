FactoryGirl.define do
  factory :bootcamper do
    sequence(:camper_id) { |n| "YTHBERLO #{n}" }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    gender "Female"
    email { Faker::Internet.email }
    week_one_lfa { Faker::Internet.email }
    week_two_lfa { Faker::Internet.email }
    country { Faker::Address.country }
    city { Faker::Address.city }
    decision_one "In Progress"
    decision_two "Not Applicable"
    cycle "02"
    overall_average "2.2"
    week1_average "2.6"
    week2_average "1.7"
    project_average "3"
    value_average "2.4"
    output_average "2.6"
    feedback_average "1.5"
    program
  end
end

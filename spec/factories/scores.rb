FactoryGirl.define do
  factory :score do
    assessment
    score Faker::Number.between(0, 2)
    week 1
    camper_id "YTHBERLO 1"
    phase
    comments Faker::Lorem.sentence
  end
end

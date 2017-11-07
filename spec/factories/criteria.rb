FactoryGirl.define do
  factory :criterium do
    name { Faker::Lorem.word }
    description { Faker::Lorem.paragraph }
  end
end

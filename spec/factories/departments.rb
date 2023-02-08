FactoryBot.define do
  factory :department do
    name{Faker::Name.name}
    description{Faker::Lorem.sentence(word_count: 5)}
  end
end

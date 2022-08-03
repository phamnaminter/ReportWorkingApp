FactoryBot.define do
  factory :comment do
    description{Faker::Lorem.sentence(word_count: 5)}
  end
end

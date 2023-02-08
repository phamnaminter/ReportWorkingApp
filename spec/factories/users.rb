FactoryBot.define do
  factory :user do
    full_name{Faker::Name.first_name}
    email{Faker::Internet.email.downcase}
    role {0}
    password{"password"}
    password_confirmation{"password"}
  end
end

 User.create!(
    full_name: "Admin User",
    email: "test@gmail.com",
    phone: "0326222333",
    password: "123456",
    password_confirmation: "123456",
    activation: true,
    role: :admin,
    activation_at: Time.zone.now
  )

99.times do |n|
  Department.create!(
    name: Faker::Name.name,
    description: Faker::Lorem.sentence(word_count: 5)
  )
end

99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(
    full_name: name,
    email: email,
    password: password,
    password_confirmation: password,
    activation: true,
    role: :normal,
    activation_at: Time.zone.now
  )
end

department = Department.first
users = User.all[0..50]
users.each { |user| department.add_user(user)}

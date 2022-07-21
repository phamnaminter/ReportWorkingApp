User.create!(
  full_name: "Admin User",
  email: "test@gmail.com",
  phone: "0326222333",
  password: "123456",
  password_confirmation: "123456",
  activation: true,
  role: :admin
  activation_at: Time.zone.now
)

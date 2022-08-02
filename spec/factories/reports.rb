FactoryBot.define do
  factory :report do
    report_date{Time.zone.now}
    today_plan{Faker::Lorem.sentence(word_count: 5)}
    today_work{Faker::Lorem.sentence(word_count: 5)}
    today_problem{Faker::Lorem.sentence(word_count: 5)}
    tomorow_plan{Faker::Lorem.sentence(word_count: 5)}
    report_status{0}
  end
end

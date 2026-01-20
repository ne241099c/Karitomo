FactoryBot.define do
  factory :member do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    sex { [1, 2].sample }
    birthday { Date.today - 20.years }
    password { "password" }
    password_confirmation { "password" }
    comment { "Hello" }

    trait :special do
      special_member { true }
      price_per_hour { 1000 }
      after(:create) do |member|
        # 09:00 to 22:00 everyday
        %w(月 火 水 木 金 土 日).each do |day|
           (9..22).each do |h|
             member.free_dates.create!(day: day, free_hour: Time.zone.parse("#{h}:00"))
           end
        end
      end
    end
  end

  factory :region do
    name { Faker::Address.city }
  end

  factory :tag do
    name { Faker::Lorem.word }
  end

  factory :admin do
    name { "admin" }
    password_digest { BCrypt::Password.create("password") }
  end
end

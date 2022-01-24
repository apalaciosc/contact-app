FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@gmail.com" }
    password         { '123123' }
  end
end

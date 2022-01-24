FactoryBot.define do
  factory :contact do
    association :user
    sequence(:email) { |n| "contact_#{n}@gmail.com" }
    name             { Faker::Name.name }
    birthday         { Faker::Date.birthday(min_age: 5, max_age: 60) }
    phone            { Faker::PhoneNumber.phone_number_with_country_code }
    address          { Faker::Address.street_name }
    credit_card      { %w[371449635398431 30569309025904 4111111111111111 5555555555554444].sample }
    trait :contact_with_visa do
      credit_card { '4111111111111111' }
      franchise { :visa }
    end
    trait :contact_with_amex do
      credit_card { '371449635398431' }
      franchise { :amex }
    end
    trait :contact_with_diners do
      credit_card { '30569309025904' }
      franchise { :diners }
    end
    trait :contact_with_mastercard do
      credit_card { '5555555555554444' }
      franchise { :mastercard }
    end
  end
end

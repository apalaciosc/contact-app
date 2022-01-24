FactoryBot.define do
  factory :contact_file do
    association :user
    status { rand(0..3) }
    file { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'factories', 'files', 'example.csv')) }
  end
end

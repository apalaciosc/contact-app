FactoryBot.define do
  factory :contact_file do
    association :user
    file { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'factories', 'files', 'example.csv')) }
  end
end

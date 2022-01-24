FactoryBot.define do
  factory :contact_file do
    association :user
    status { rand(0..3) }

    after(:build) do |contact_file|
      contact_file.file.attach(
        io: File.open(Rails.root.join('spec', 'factories', 'files', 'example.csv')),
        filename: 'example.csv',
        content_type: 'text/csv'
      )
    end
  end
end

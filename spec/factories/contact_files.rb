FactoryBot.define do
  factory :contact_file do
    association :user
    file { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'factories', 'files', 'example.csv')) }

    before(:create) do |contact_file|
      file_columns = {
        name: 'Name',
        birthday: 'Date Of Birth',
        phone: 'Phone',
        address: 'Address',
        credit_card: 'Credit Card',
        email: 'Email'
      }
      file_columns.each do |key, value|
        contact_file.file_columns.new(
          field: key,
          column_name: value
        )
      end
    end
  end
end

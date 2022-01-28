class FileColumn < ApplicationRecord
  FIELDS = %i[
    name
    birthday
    phone
    address
    credit_card
    email
  ].freeze

  # Relations
  belongs_to :contact_file

  # Enums
  enum field: FIELDS, _suffix: :field

  # Validations
  validates_presence_of :column_name, :field
end

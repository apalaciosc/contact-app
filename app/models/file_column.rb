class FileColumn < ApplicationRecord
  # Relations
  belongs_to :contact_file

  # Enums
  enum field: %i[name birthday phone address credit_card email], _suffix: :field

  # Validations
  validates_presence_of :column_name, :field
end

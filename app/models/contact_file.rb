class ContactFile < ApplicationRecord
  # Relations
  belongs_to :user
  has_one_attached :file

  # Enum
  enum status: %i[on_hold processing failed terminated]
end

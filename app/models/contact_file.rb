class ContactFile < ApplicationRecord
  # Relations
  belongs_to :user
  has_many :file_columns, dependent: :destroy
  has_one_attached :file
  accepts_nested_attributes_for :file_columns

  # Enum
  enum status: %i[on_hold processing failed terminated]

  # Callbacks
  after_create :enqueue_importation

  # Serializers
  serialize :row_errors, Array
  before_validation :validate_file_columns

  def badge
    return 'primary' if on_hold?
    return 'info' if processing?
    return 'danger' if failed?
    return 'success' if terminated?
  end

  # Callbacks

  def enqueue_importation
    ImportContactsJob.perform_later(id)
  end

  def validate_file_columns
    return if file_columns.map(&:field).map(&:to_sym).sort == FileColumn::FIELDS.sort

    errors.add(:base, 'Invalid fields')
  end
end

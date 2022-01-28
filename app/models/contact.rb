class Contact < ApplicationRecord
  include Insertable

  REGULAR_EXPRESSION_MASK_CREDIT_CARD = /.(?=....)/.freeze
  CREDIT_CARD_FRANCHISES = %i[
    amex
    diners
    discover
    jcb
    mastercard
    visa
  ].freeze

  # Relations
  belongs_to :user

  # Enums
  enum franchise: CREDIT_CARD_FRANCHISES

  # Callbacks
  before_create :mask_card_number

  def mask_card_number
    self.credit_card = credit_card&.gsub(REGULAR_EXPRESSION_MASK_CREDIT_CARD, '*')
  end

  def self.normalize(records)
    records.each do |rec|
      add_timestamp(rec)
      rec[:credit_card] = rec[:credit_card]&.gsub(REGULAR_EXPRESSION_MASK_CREDIT_CARD, '*')
    end
  end
end

class FindFranchise < ApplicationService
  FRANCHISE_REGULAR_EXPRESSIONS_VALIDATOR = {
    amex: /^3[47][0-9]{13}$/,
    diners: /^3(?:0[0-5]|[68][0-9])[0-9]{11}$/,
    discover: /^6(?:011|5[0-9]{2})[0-9]{12}$/,
    jcb: /^(?:2131|1800|35\d{3})\d{11}$/,
    mastercard: /^5[1-5][0-9]{14}$/,
    visa: /^4[0-9]{12}(?:[0-9]{3})?$/
  }.freeze
  attr_accessor :credit_card_number

  def initialize(credit_card_number)
    @credit_card_number = credit_card_number
  end

  def call
    FRANCHISE_REGULAR_EXPRESSIONS_VALIDATOR.detect do |_key, value|
      value.match?(credit_card_number)
    end&.first
  end
end

class ValidateCreditCard < ApplicationService
  RULES = {
    amex: { min_length: 15, max_lenght: 15 },
    diners: { min_length: 14, max_lenght: 19 },
    discover: { min_length: 16, max_lenght: 19 },
    jcb: { min_length: 16, max_lenght: 19 },
    mastercard: { min_length: 16, max_lenght: 16 },
    visa: { min_length: 13, max_lenght: 16 }
  }

  STEPS = %w[
    validate_length
  ].freeze

  attr_accessor :credit_card_number, :franchise

  def initialize(credit_card_number, franchise)
    @credit_card_number = credit_card_number
    @franchise = franchise
  end

  def call
    return false if credit_card_number&.empty? || franchise&.empty?

    STEPS.reject do |step|
      send(step)
    end.empty?
  end

  private

  def validate_length
    credit_card_number.length.between?(RULES[franchise][:min_length], RULES[franchise][:max_lenght])
  end

  def validate_luhn
    sum1 = 0
    sum2 = 0
    credit_card_number.reverse.chars.each_slice(2) do |odd, even|
      # Accumulate the odds
      sum1 += odd.to_i

      # Multiply by 2 the evens
      double = even.to_i * 2
      # Subtract 9 if even * 2 greater than or equal to 10
      double -= 9 if double >= 10
      # Accumulate the result
      sum2 += double
    end
    # Both sums must be divisible by 10
    ((sum1 + sum2) % 10).zero?
  end
end

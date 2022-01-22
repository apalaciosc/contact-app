class Contact < ApplicationRecord
  CREDIT_CARD_FRANCHISES = %i[
    amex
    unionpay
    dankort
    diners
    elo
    discover
    hipercard
    jcb
    maestro
    mastercard
    mir
    rupay
    solo
    switch
    visa
  ].freeze

  # Relations
  belongs_to :user

  # Enums
  enum franchise: CREDIT_CARD_FRANCHISES
end

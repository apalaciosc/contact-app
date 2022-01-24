require 'rails_helper'

RSpec.describe Contact, type: :model do
  context 'associations' do
    it { should belong_to(:user) }
    it { should define_enum_for(:franchise).with_values(Contact::CREDIT_CARD_FRANCHISES) }
  end

  context 'create' do
    it 'must create a contact and mask the credit card number' do
      contact = create(:contact, :contact_with_amex)

      expect(contact.amex?).to eq(true)
      expect(contact.credit_card).to eq('***********8431')
    end
  end
end

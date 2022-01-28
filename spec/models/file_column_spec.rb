require 'rails_helper'

RSpec.describe FileColumn, type: :model do
  context 'associations' do
    it { should belong_to(:contact_file) }
    it { should validate_presence_of(:column_name) }
    it { should validate_presence_of(:field) }
    it do
      should define_enum_for(:field).with_values(%i[name birthday phone address credit_card email]).with_suffix(:field)
    end
  end
end

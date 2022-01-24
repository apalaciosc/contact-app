require 'rails_helper'

RSpec.describe ContactFile, type: :model do
  include ActiveJob::TestHelper
  after { clear_enqueued_jobs }

  context 'associations' do
    it { should belong_to(:user) }
    it { should define_enum_for(:status).with_values(%i[on_hold processing failed terminated]) }
  end

  context 'create' do
    it 'must enqueue ImportContactsJob and create contact_file in status on_hold' do
      contact_file = create(:contact_file)

      expect(contact_file.on_hold?).to eq(true)
      expect(enqueued_jobs.detect { |a| a['job_class'] == ImportContactsJob.to_s }).not_to be_nil
    end
  end
end

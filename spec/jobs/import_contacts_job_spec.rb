require 'rails_helper'

RSpec.describe ImportContactsJob, type: :job do
  describe 'success cases' do
    context 'with two valid contacts' do
      let!(:contact_file) { create(:contact_file, file: file('valid_files', 'with_two_valid_contacts')) }

      before do
        described_class.perform_now(contact_file.id)
        contact_file.reload
      end

      it { expect(contact_file.terminated?).to eq(true) }
      it { expect(contact_file.row_errors).to eq([]) }
      it { expect(contact_file.user.contacts.count).to eq(2) }
      it { expect(contact_file.user.contacts.first.franchise).to eq('amex') }
      it { expect(contact_file.user.contacts.first.credit_card).to eq('***********8431') }
    end

    context 'repeated email but from another user' do
      let(:repeated_email)             { 'adrian@gmail.com' }
      let!(:contact_file)              { create(:contact_file, file: file('valid_files', 'repeated_email_valid')) }
      let!(:contact_from_another_user) { create(:contact, email: repeated_email) }

      before do
        described_class.perform_now(contact_file.id)
        contact_file.reload
      end

      it { expect(contact_file.terminated?).to eq(true) }
      it { expect(contact_file.row_errors).to eq([]) }
      it { expect(contact_file.user.contacts.count).to eq(1) }
      it { expect(contact_file.user.contacts.first.email).to eq(contact_from_another_user.email) }
    end

    context 'empty file' do
      let!(:contact_file) { create(:contact_file, file: file('valid_files', 'empty')) }

      before do
        described_class.perform_now(contact_file.id)
        contact_file.reload
      end

      it_behaves_like('empty csv file expect results')
    end

    context 'only with columns file' do
      let!(:contact_file) { create(:contact_file, file: file('valid_files', 'only_with_columns')) }

      before do
        described_class.perform_now(contact_file.id)
        contact_file.reload
      end

      it_behaves_like('empty csv file expect results')
    end
  end

  describe 'invalid cases' do
    context 'with invalid email' do
      let!(:contact_file) { create(:contact_file, file: file('invalid_files', 'invalid_email')) }

      before do
        described_class.perform_now(contact_file.id)
        contact_file.reload
      end

      it_behaves_like('invalid csv results')
      it { expect(contact_file.row_errors).to eq([{ row: 2, errors: ['email'] }]) }
    end

    context 'with repeated email' do
      let(:repeated_email)             { 'adrian@gmail.com' }
      let!(:contact_file)              { create(:contact_file, file: file('invalid_files', 'repeated_email')) }
      let!(:contact_from_same_user)    { create(:contact, email: repeated_email, user: contact_file.user) }

      before do
        described_class.perform_now(contact_file.id)
        contact_file.reload
      end

      it { expect(contact_file.failed?).to eq(true) }
      it { expect(contact_file.user.contacts.count).to eq(1) }
      it { expect(contact_file.row_errors).to eq([{ row: 2, errors: ['repeated_email'] }]) }
    end

    context 'with incomplete columns' do
      let!(:contact_file) { create(:contact_file, file: file('invalid_files', 'incomplete_columns')) }

      before do
        described_class.perform_now(contact_file.id)
        contact_file.reload
      end

      it_behaves_like('invalid csv results')
      it { expect(contact_file.row_errors).to eq([{ row: 1, errors: ['invalid_columns'] }]) }
    end

    context 'with incomplete data' do
      let!(:contact_file) { create(:contact_file, file: file('invalid_files', 'incomplete_data')) }

      before do
        described_class.perform_now(contact_file.id)
        contact_file.reload
      end

      it_behaves_like('invalid csv results')
      it { expect(contact_file.row_errors).to eq([{ row: 2, errors: %w[phone credit_card] }]) }
    end

    context 'with invalid name' do
      let!(:contact_file) { create(:contact_file, file: file('invalid_files', 'invalid_name')) }

      before do
        described_class.perform_now(contact_file.id)
        contact_file.reload
      end

      it_behaves_like('invalid csv results')
      it { expect(contact_file.row_errors).to eq([{ row: 2, errors: ['name'] }]) }
    end

    context 'with invalid phone' do
      let!(:contact_file) { create(:contact_file, file: file('invalid_files', 'invalid_phone')) }

      before do
        described_class.perform_now(contact_file.id)
        contact_file.reload
      end

      it_behaves_like('invalid csv results')
      it { expect(contact_file.row_errors).to eq([{ row: 2, errors: ['phone'] }]) }
    end

    context 'with invalid date' do
      let!(:contact_file) { create(:contact_file, file: file('invalid_files', 'invalid_date')) }

      before do
        described_class.perform_now(contact_file.id)
        contact_file.reload
      end

      it_behaves_like('invalid csv results')
      it { expect(contact_file.row_errors).to eq([{ row: 2, errors: ['birthday'] }]) }
    end
  end

  def file(folder, file_name)
    path = File.new("#{Rails.root}/spec/factories/files/#{folder}/#{file_name}.csv").path
    Rack::Test::UploadedFile.new(path)
  end
end

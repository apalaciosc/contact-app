shared_examples 'empty csv file expect results' do
  it { expect(contact_file.terminated?).to eq(true) }
  it { expect(contact_file.row_errors).to eq([]) }
  it { expect(contact_file.user.contacts.count).to eq(0) }
end

shared_examples 'invalid csv results' do
  it { expect(contact_file.failed?).to eq(true) }
  it { expect(contact_file.user.contacts.count).to eq(0) }
end

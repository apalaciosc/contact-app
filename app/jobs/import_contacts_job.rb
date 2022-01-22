class ImportContactsJob < ApplicationJob
  queue_as :default

  def perform(contact_file_id)
    contact_file = ContactFile.find(contact_file_id)
    puts contact_file
  end
end

class ImportContactsJob < ApplicationJob
  queue_as :default

  def perform(contact_file_id)
    contact_file = ContactFile.find(contact_file_id)
    contact_file.processing!

    ContactImporter.call(contact_file)
  rescue StandardError
    contact_file.failed!
  end
end

class ContactImporter < ApplicationService
  require 'credit_card_validations/string'

  REGULAR_EXPRESSION_NAME = /^[a-zA-Z\dáÁéÉíÍóÓúÚüÜñÑ\s-]*$/i.freeze
  NUMBER_COLUMNS = 6
  STEPS = %w[
    validate_empty_file
    validate_columns
    import_data
  ].freeze
  VALIDATION_KEYS = %w[
    name
    birthday
    phone
    credit_card
    email
    repeated_email
  ].freeze

  attr_accessor :contact_file, :csv

  def initialize(contact_file)
    @contact_file = contact_file
    @csv = Roo::CSV.new(
      ActiveStorage::Blob.service.send(:path_for, contact_file.file.key)
    )
  end

  def call
    STEPS.each do |step|
      result = send(step)
      break unless result
    end
    contact_file.save!
  end

  private

  def validate_empty_file
    return true unless csv.row(1)&.compact&.empty? || csv.last_row == 1

    contact_file.terminated!
    false
  end

  def validate_columns
    return true if csv.row(1).count == NUMBER_COLUMNS

    contact_file.status = :failed
    contact_file.row_errors << { row: 1, errors: ['invalid_columns'] }
    false
  end

  def import_data
    Contact.insert_all_normalized(contact_data)
    contact_file.terminated!
  rescue ArgumentError
    contact_file.failed!
  end

  def contact_data
    (2..csv.last_row).map do |row_number|
      row = Hash[[csv.row(1), csv.row(row_number)].transpose]
      result = validate_params(row_params(row), row_number)

      row_params(row) if result
    end.compact
  end

  def validate_params(row_params, row_number)
    errors = VALIDATION_KEYS.map do |key|
      next if send("validate_#{key}", row_params)

      key
    end.compact
    contact_file.row_errors << { row: row_number, errors: errors } unless errors.empty?

    errors.empty?
  end

  def validate_name(row_params)
    REGULAR_EXPRESSION_NAME.match?(row_params[:name])
  end

  def validate_birthday(row_params)
    (/\d{4}-\d{2}-\d{2}/.match?(row_params[:birthday]) || /\d{8}/.match?(row_params[:birthday])) &&
      Date.iso8601(row_params[:birthday]).present?
  rescue ArgumentError
    false
  end

  def validate_phone(row_params)
    Phonelib.valid_for_country?(row_params[:phone]&.gsub(/[^0-9A-Za-z]/, ''), 'CO')
  end

  def validate_credit_card(row_params)
    detector = CreditCardValidations::Detector.new(row_params[:credit_card])
    detector.valid?(row_params[:franchise])
  rescue StandardError
    false
  end

  def validate_email(row_params)
    URI::MailTo::EMAIL_REGEXP.match?(row_params[:email])
  end

  def validate_repeated_email(row_params)
    contact_emails.empty? { |email| email == row_params[:email] }
  end

  def contact_emails
    @contact_emails ||= contact_file.user.contacts.pluck(:email)
  end

  def row_params(row)
    return @row_params if @row_params.present?

    @row_params = {}
    contact_file.file_columns.each do |file_column|
      @row_params[file_column.field.to_sym] = row[file_column.column_name]
    end
    @row_params.merge!(
      user_id: contact_file.user_id,
      franchise: credit_card_field&.credit_card_brand
    )
    @row_params
  end

  def credit_card_field
    @row_params[contact_file.file_columns.find_by(field: 'credit_card')&.field&.to_sym]
  end
end

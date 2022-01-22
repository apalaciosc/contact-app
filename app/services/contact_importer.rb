class ContactImporter < ApplicationService
  attr_accessor :contact_file, :csv

  REGULAR_EXPRESSION_NAME = /^[a-zA-Z\dáÁéÉíÍóÓúÚüÜñÑ\s-]*$/i.freeze
  NUMBER_COLUMNS = 6
  STEPS = %w[
    validate_columns
    import_data
  ].freeze
  VALIDATION_KEYS = %w[
    name
  ].freeze

  def initialize(contact_file)
    super

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

  def validate_columns
    return true if csv.row(1).count == NUMBER_COLUMNS

    contact_file.status = :failed
    contact_file.errors << { errors: ['Invalid Columns'] }
    false
  end

  def import_data
    # Acá se crean los registros a partir de la data
    contact_data
  end

  def contact_data
    (2..csv.last_row).map do |number_row|
      row = Hash[[csv.row(1), csv.row(number_row)].transpose]
      result, key_errors = validate_params(row_params(row))

      result ? row_params(row) : contact_file.errors << { row: number_row, errors: key_errors }
    end.compact
  end

  def validate_params(row_params)
    errors = VALIDATION_KEYS.map do |key|
      next if send("validate_#{key}", row_params)

      key
    end.compact
    [errors.empty?, errors]
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

  def row_params(row)
    {
      user_id: contact_file.user_id,
      name: row['Name'],
      birthday: row['Date Of Birth'],
      phone: row['Phone'],
      address: row['Address'],
      credit_card: row['Credit Card'],
      email: row['Email'],
      franchise: row['Credit Card']&.credit_card_brand
    }
  end
end

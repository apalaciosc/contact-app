module FileColumnsHelper
  def fields_for_select
    FileColumn.fields.keys.map do |file_column_key|
      [file_column_key.humanize, file_column_key]
    end
  end
end

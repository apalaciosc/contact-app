module Insertable
  extend ActiveSupport::Concern
  class_methods do
    def add_timestamp(record)
      time = Time.now.utc
      record['created_at'] = time
      record['updated_at'] = time
    end

    def insert_all_normalized(records, options = { returning: [:id] })
      normalized = normalize(records)
      result = nil
      begin
        result = insert_all(normalized, options)
      rescue ActiveRecord::StatementInvalid => e
        result = e
      end
      result
    end
  end
end

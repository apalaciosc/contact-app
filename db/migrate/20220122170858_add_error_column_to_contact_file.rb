class AddErrorColumnToContactFile < ActiveRecord::Migration[6.0]
  def change
    add_column :contact_files, :row_errors, :text
  end
end

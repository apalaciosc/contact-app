class CreateFileColumns < ActiveRecord::Migration[6.0]
  def change
    create_table :file_columns do |t|
      t.references :contact_file, null: false, foreign_key: true
      t.string :column_name
      t.integer :field

      t.timestamps
    end
  end
end

class CreateContactFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :contact_files do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :status, default: 0

      t.timestamps
    end
  end
end

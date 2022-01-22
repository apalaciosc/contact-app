class CreateContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.date :birthday
      t.string :phone
      t.string :address
      t.string :credit_card
      t.integer :franchise
      t.string :email

      t.timestamps
    end
  end
end

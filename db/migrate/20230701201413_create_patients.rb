class CreatePatients < ActiveRecord::Migration[7.0]
  def change
    create_table :patients do |t|
      t.integer :health_identifier
      t.string :health_identifier_province
      t.string :first_name
      t.string :last_name
      t.string :middle_name
      t.string :phone_code
      t.string :phone_number
      t.string :email

      t.timestamps
    end
  end
end

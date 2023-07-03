class CreatePatients < ActiveRecord::Migration[7.0]
  def change
    create_table :patients do |t|
      t.integer :health_identifier
      t.integer :health_identifier_province
      t.string :first_name
      t.string :last_name
      t.string :middle_name
      t.string :phone_number
      t.string :email
      t.string :address_1
      t.string :address_2
      t.integer :province
      t.string :city
      t.string :postal_code
      t.date :date_of_birth
      t.integer :sex

      t.timestamps
    end
  end
end

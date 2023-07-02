class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.belongs_to :patient
      t.string :city
      t.string :street_name
      t.string :street_number
      t.string :zip_code
      t.text :additional_info
      t.bigint :country_id

      t.timestamps
    end
  end
end

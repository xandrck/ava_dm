class CreateDataMigrations < ActiveRecord::Migration[7.0]
  def change
    create_table :data_migrations do |t|
      t.integer :imported_patients
      t.float :migration_time
      t.integer :updates_patients
      t.integer :failed_patients
      t.string :migration_errors

      t.timestamps
    end
  end
end

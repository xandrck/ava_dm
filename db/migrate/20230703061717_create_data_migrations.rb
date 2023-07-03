class CreateDataMigrations < ActiveRecord::Migration[7.0]
  def change
    create_table :data_migrations do |t|
      t.integer :imported_patients, default: 0
      t.float :migration_time, default: 0
      t.integer :updates_patients, default: 0
      t.integer :failed_patients, default: 0
      t.jsonb :migration_errors, default: {}

      t.timestamps
    end
  end
end

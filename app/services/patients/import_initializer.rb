module Patients::ImportInitializer
  def initialize(data_migration_id:, file:)
    @file = file
    @patients_data = []
    @errors = []
    @errors_data = []
    @success = true
    @line_number = 0
    @data_migration = DataMigration.find_or_create_by(id: data_migration_id)
    @invalid_records_service = invalid_records_generator_service
    @result = []
  end

  private

  def invalid_records_generator_service
    Patients::Csv::InvalidRecordsGenerator.new(data_migration: data_migration)
  end
end

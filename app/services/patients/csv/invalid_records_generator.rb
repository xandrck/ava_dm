class Patients::Csv::InvalidRecordsGenerator < InvalidRecordsCsvGenerator
  HEADERS = [
    'health identifier',
    'health identifier province',
    'first name',
    'last name',
    'middle name',
    'phone',
    'email',
    'address 1',
    'address 2',
    'address province',
    'address city',
    'address postal code',
    'date of birth',
    'sex',
    'errors'
  ]

  FILE_NAME = 'invalid_patients.csv'

  def initialize(data_migration:)
    @data_migration = data_migration
    @file_path = "#{dir_name}/#{FILE_NAME}"
  end

  attr_reader :file_path

  def file
    File.open(file_path, 'a')
  end

  private

  attr_reader :data_migration

  # case when data_migration will not create file should be also covered
  def dir_name
    File.dirname(data_migration.file_path)
  end
end

require 'fileutils'
class DataMigrations::Log
  def initialize(file)
    @file = file
    @data_migration = DataMigration.create
  end

  attr_reader :data_migration

  def call
    data_migration.file.attach(@file)

    data_migration.file.blob.open do |file|
      FileUtils.mkdir_p(File.dirname(data_migration.file_path))
      FileUtils.cp(file.path, data_migration.file_path)
    end
  # rescue ActiveSupport::MessageVerifier::InvalidSignature => error
  #   Rails.logger.error(error)
  # rescue StandardError => error
  #   Rails.logger.error(error)
  end
end

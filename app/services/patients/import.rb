# frozen_string_literal: true

require 'csv'
require_relative 'import_attributes'
require_relative 'import_validator'

# using Struct service could be updated so we could simplify usage and response

class Patients::Import
  include Patients::ImportValidator, Patients::ImportAttributes

  def initialize(data_migration_id:, file:)
    @file = file
    @patients_data = []
    @errors = []
    @success = true
    @line_number = 0
    @data_migration = DataMigration.find_or_create_by(id: data_migration_id)
  end

  attr_reader :errors

  # depends on requirements we could not just create but also update records
  def call
    return errors << 'Headers mismatched.' unless headers_match?
    return errors << "Content type is not valid: #{file.content_type}" unless file_content_type_valid?

    CSV.foreach(file.path, headers: true) do |row|
      critical_error = []
      @line_number += 1

      unless integer_field?(row['health identifier'])
        critical_error << ["Field health identifier: (#{row['health identifier']}) is not an integer"]
      end

      unless sex_valid?(row['sex'])
        critical_error << ["Field sex: (#{row['sex']}) is not valid"]
      end

      if critical_error.present?
        errors << { row_number: @line_number, errors: critical_error }
        next
      end

      # add validation of sex before saving, now we will send nil for non existing sex

      patient_data = patient_attributes(row)
      patient = Patient.new(patient_data)

      if patient.valid?
        patients_data << patient_data
      else
        errors << { row_number: @line_number, errors: patient.errors.full_messages }
      end
    end

    Patient.insert_all(patients_data) if patients_data.present?
  rescue StandardError => error
    @success = false
    Rails.logger.error(error)
    # we could add logging here and return for user simple error
    errors << error
  ensure
    migration_time = Time.now - data_migration.created_at.to_time
    data_migration.update(
      imported_patients: patients_data.size,
      failed_patients: errors.count,
      migration_errors: errors.to_json,
      migration_time: migration_time
    )
  end

  def success?
    @success
  end

  private

  attr_reader :file, :patients_data, :data_migration
  attr_writer :errors
end
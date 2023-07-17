# frozen_string_literal: true

require 'csv'
require_relative 'import_attributes'
require_relative 'import_validator'
require_relative 'import_initializer'
require_relative 'csv/error_recorder'

# using Struct service could be updated so we could simplify usage and response

class Patients::Import
  include Patients::ImportValidator,
          Patients::ImportAttributes,
          Patients::ImportInitializer,
          Patients::Csv::ErrorRecorder

  attr_reader :errors, :errors_data

  # depends on requirements we could not just create but also update records
  def call
    return errors << 'Headers mismatched.' unless headers_match?
    return errors << "Content type is not valid: #{file.content_type}" unless file_content_type_valid?

    # create CSV file for invalid records
    # we could also delete this file in case it contain only headers
    invalid_records_service.generate_csv

    CSV.foreach(file_path, headers: true) do |row|
      critical_error = []
      @line_number += 1

      unless integer_field?(row['health identifier'])
        critical_error << ["Field health identifier: (#{row['health identifier']}) is not an integer"]
      end

      unless sex_valid?(row['sex'])
        critical_error << ["Field sex: (#{row['sex']}) is not valid"]
      end

      if critical_error.present?
        errors_data << patient_attributes(row).merge(errors: critical_error)
        errors << { row_number: @line_number, errors: critical_error }
        next
      end

      # add validation of sex before saving, now we will send nil for non existing sex

      patient_data = patient_attributes(row)
      patient = Patient.new(patient_data)

      if patient.valid?
        patients_data << patient_data
      else
        errors_data << patient_attributes(row).merge(errors: patient.errors.full_messages)
        errors << { row_number: @line_number, errors: patient.errors.full_messages }
      end
    end

    # if we will use Address as and additional model we will need to use Transaction and think about improvement of creation records speed
    return if patients_data.empty?

    @result = Patient.insert_all(patients_data)

    # Get the duplicated records from the result
  rescue StandardError => error
    @success = false
    Rails.logger.error(error)
    # we could add logging here and return for user simple error
    errors << error
  ensure
    record_errors
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

  attr_reader :file, :patients_data, :data_migration, :invalid_records_service, :result
  attr_writer :errors, :errors_data

  def file_path
    file.try(:path) || file.service.path_for(file.key)
  end
end
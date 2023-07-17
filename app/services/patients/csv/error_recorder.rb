module Patients::Csv::ErrorRecorder
  # record duplicates records and records with failed validation
  def record_errors
    array = duplicated_records + errors_data

    write_to_csv(array, invalid_records_service.file_path)
    invalid_records_service.file.close
  end

  private

  def write_to_csv(array_hashes, csv_file_path)
    CSV.open(csv_file_path, 'a') do |csv|
      array_hashes.each do |hash|
        csv << hash.values
      end
    end
  end

  def duplicated_records
    @duplicated_records ||= result.reject { |r| r.is_a?(Hash) }
  end
end

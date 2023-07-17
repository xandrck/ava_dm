# frozen_string_literal: true
require 'csv'

class InvalidRecordsCsvGenerator
  HEADERS = []
  FILE_NAME = 'invalid_records.csv'

  def generate_csv
    CSV.open(file_path, 'w') do |csv|
      csv << self.class::HEADERS
    end
  end
end

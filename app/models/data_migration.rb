class DataMigration < ApplicationRecord
  has_one_attached :file

  def file_path
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    "tmp/#{model_name}/#{timestamp}/#{file.filename}"
  end
end

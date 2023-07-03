class PatientsController < ApplicationController
  before_action :file_present?, only: :import
  def index
    @patients = Patient.order(:health_identifier)
  end

  def import
    # services could be called in job
    data_migration_service.call
    import_service.call

    redirect_to patients_path, notice: 'Something goes wrong, check migration details.' and return unless import_service.success?

    redirect_to patients_path, notice: 'Patients imported.'
  end

  private

  def file
    params[:file] || blob
  end

  def blob
    @blob ||= ActiveStorage::Blob.find_by(id: params[:file_blob_id])
  end

  def import_service
    @import_service ||= Patients::Import.new(data_migration_id: data_migration.id, file: file)
  end

  def data_migration_service
    @data_migration_service ||= DataMigrations::Log.new(file)
  end

  def data_migration
    @data_migration ||= data_migration_service.data_migration
  end

  # could be as an additional check
  def file_present?
    redirect_to patients_path, notice: 'Choose file for upload.' if file.blank?
  end
end

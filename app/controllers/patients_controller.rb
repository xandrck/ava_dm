class PatientsController < ApplicationController
  before_action :file_present?, only: :import
  def index
    @patients = Patient.all
  end

  def import
    # move to the job
    service.call

    redirect_to patients_path, notice: service.errors.join(', ') and return unless service.success?

    notice = service.errors ? service.errors.join(', ') : 'Patients imported started.'
    redirect_to patients_path, notice: notice
  end

  private

  def file
    params[:file]
  end

  def service
    @service ||= Patients::Import.new(file)
  end

  # could be as an additional check
  def file_present?
    redirect_to patients_path, notice: 'Choose file for upload.' if file.blank?
  end
end

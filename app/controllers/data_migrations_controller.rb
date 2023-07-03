class DataMigrationsController < ApplicationController
  def index
    @data_migrations = DataMigration.includes(:file_attachment).order(created_at: :desc)
  end

  def show
    @data_migration = DataMigration.find(params[:id])
  end
end

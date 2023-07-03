class DataMigrationsController < ApplicationController
  def index
    @data_migrations = DataMigration.all
  end
end

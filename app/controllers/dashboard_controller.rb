class DashboardController < ApplicationController
  def index
    sql = 'SELECT COUNT(id) as total_migrations,
                  SUM(imported_patients) AS total_imported_patients,
                  SUM(updates_patients) AS total_updates_patients,
                  SUM(failed_patients) AS total_failed_patients
           FROM data_migrations'

    @statistic = DataMigration.find_by_sql(sql).first
  end
end

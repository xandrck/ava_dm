module DataMigrationsHelper
  def format_migration_errors(json)
    return if json.blank?

    parsed_errors = JSON.parse(json)
    parsed_errors.each do |hash|
      concat(content_tag(:pre, hash.pretty_inspect))
    end
  end
end

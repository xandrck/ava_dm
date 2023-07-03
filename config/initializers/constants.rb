# frozen_string_literal: true

# we could get data dynamically by using
# provinces_hash = {}
# ISO3166::Country.find_country_by_alpha2('CA').states.values.each { |province| provinces_hash[province.code] = province.name }
# by using countries gem

AVAILABLE_PROVINCES = {
  'AB' => 'Alberta',
  'BC' => 'British Columbia',
  'MB' => 'Manitoba',
  'NB' => 'New Brunswick',
  'NL' => 'Newfoundland and Labrador',
  'NS' => 'Nova Scotia',
  'NT' => 'Northwest Territories',
  'NU' => 'Nunavut',
  'ON' => 'Ontario',
  'PE' => 'Prince Edward Island',
  'QC' => 'Quebec',
  'SK' => 'Saskatchewan',
  'YT' => 'Yukon'
}

PROVINCES_ENUM = AVAILABLE_PROVINCES.invert.each_with_object({}).with_index do |((key, value), hash), index|
  hash[value] = index
end

SEX_ENUM = {
  'M' => 0,
  'F' => 1
}
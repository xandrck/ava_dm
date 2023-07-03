module Patients::ImportValidator
  CSV_HEADERS = [
    'health identifier',
    'health identifier province',
    'first name',
    'last name',
    'middle name',
    'phone',
    'email',
    'address 1',
    'address 2',
    'address province',
    'address city',
    'address postal code',
    'date of birth',
    'sex'
  ]

  def headers_match?
    csv_headers = CSV.open(file_path, &:readline)

    csv_headers == CSV_HEADERS
  end

  def file_content_type_valid?
    file.content_type == 'text/csv'
  end

  def integer_field?(value)
    Integer(value)
    true
  rescue ArgumentError
    false
  end

  # add validation of data fields

  # could be added sanitize to make should that key and value will be similar to available
  # 'AB' => 'Alberta'
  # to work with 'ab', 'aLbErta', etc..
  def province_name(row_value)
    return row_value if AVAILABLE_PROVINCES.keys.include?(row_value)

    AVAILABLE_PROVINCES.key(row_value) if AVAILABLE_PROVINCES.values.include?(row_value)
  end

  def sex_name(row_value)
    row_value.upcase if sex_valid?(row_value)
  end

  def sex_valid?(row_value)
    SEX_ENUM.keys.include?(row_value.upcase)
  end

  # not sure if we need to validate name of the CSV file, but we could if we need to
end

module Patients::ImportAttributes
  def patient_attributes(row)
    {
      health_identifier: row['health identifier'],
      health_identifier_province: province_name(row['health identifier province']),
      first_name: row['first name'],
      last_name: row['last name'],
      middle_name: row['middle name'],
      phone_number: row['phone'],
      email: row['email'],
      address_1: row['address 1'],
      address_2: row['address 2'],
      province: province_name(row['address province']),
      city: row['address city'],
      postal_code: row['address postal code'],
      date_of_birth: row['date of birth'],
      sex: sex_name(row['sex'])
    }
  end
end

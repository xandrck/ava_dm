# frozen_string_literal: true

class Patient < ApplicationRecord
  enum health_identifier_province: PROVINCES_ENUM
  # enum province: PROVINCES_ENUM
  enum sex: SEX_ENUM

  validates :health_identifier,
            :health_identifier_province,
            :first_name,
            :last_name,
            :phone_number,
            :email,
            :province,
            :city,
            :postal_code,
            :date_of_birth,
            :sex,
            presence: true
  validates :health_identifier, uniqueness: { scope: :health_identifier_province }

  # Depends on requirement we could use Address model here
  # we could optimize address usage, to allow re-use address without creating new one
  # for example family of patients could have one address
  # But to speed up creation better to store all data in one table

  # We could use "phonelib" for better validation and getting benefits for using phones in future
  # I didn't add it here since we will need to added validation and complicate upload of CSV logic
  # That mean that it will increase time that need to spent on task
  # depends on requirements we could add more validation
end

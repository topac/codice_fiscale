require 'rubygems'
require 'date'
require 'csv'
require 'active_support/core_ext/object/blank'
require 'codice_fiscale/version'
require 'codice_fiscale/alphabet'
require 'codice_fiscale/codes'
require 'codice_fiscale/configuration'
require 'codice_fiscale/string_helper'

module CodiceFiscale
  include StringHelper
  extend self

  def calculate params
    validate_calculate_params params
    code = birthplace_part (params[:country_name] || Codes::ITALY), params[:city_name], params[:province_code]
    raise "Missing city/country code. Mispelled?" unless code
    code = surname_part(params[:surname]) + name_part(params[:name]) + birthdate_part(params[:birthdate], params[:gender]) + code
    code + check_character(code)
  end

  def validate_calculate_params params
    [:name, :surname, :gender, :birthdate].each do |param_name|
      raise ArgumentError.new("Missing #{param_name} parameter") if params[param_name].blank?
    end
    raise ArgumentError.new("Invalid birthdate: #{params[:birthdate]}") unless params[:birthdate].respond_to? :year
    unless Codes::GENDERS.include? params[:gender]
      raise ArgumentError.new("Invalid gender. Possible values are #{Codes::GENDERS}")
    end
  end


  # Methods to generate each part of the code

  def surname_part surname
    surname.upcase!
    code = first_three_consonants surname
    code << first_three_vowels(surname)
    truncate_and_right_pad_with_three_x code
  end

  def name_part name
    name.upcase!
    consonants_of_name = consonants name
    return consonants_of_name[0]+consonants_of_name[2..3] if consonants_of_name.size >= 4
    code = first_three_consonants name
    code << first_three_vowels(name)
    truncate_and_right_pad_with_three_x code
  end

  def birthdate_part birthdate, gender
    code = birthdate.year.to_s[2..3]
    code << Codes.month_letter(birthdate.month)
    day_part = gender.to_s.downcase[0] == 'f' ? birthdate.day + 40 : birthdate.day
    code << "#{day_part}".rjust(2, '0')
  end

  def city_code city_name, province_code
    return config.city_code.call(city_name, province_code) if config.city_code
    Codes.city city_name, province_code
  end

  def country_code country_name
    return config.country_code.call(country_name) if config.country_code
    Codes.country country_name
  end

  def birthplace_part country_name, city_name = nil, province_code = nil
    if Codes.italy? country_name
      city_code city_name, province_code
    else
      country_code country_name
    end
  end

  # todo - rename to control_character
  def check_character partial_fiscal_code
    numeric_value = 0
    partial_fiscal_code.split('').each_with_index do |chr, index|
      numeric_value += (index+1).even? ? Codes.even_character(chr) : Codes.odd_character(chr)
    end
    Codes.check_character numeric_value % 26
  end
end
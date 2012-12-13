module CodiceFiscale
  class FiscalCode
    include Helpers

    attr_accessor :italian_citizen
    alias :citizen :italian_citizen

    delegate :name, :surname, :birthdate, :city_name, :province_code, :country_name, :to => :citizen

    def initialize italian_citizen
      @italian_citizen = italian_citizen
    end

    def calculate
      code = birthplace_part
      raise "Cannot find a valid code for #{[country_name, city_name, province_code].compact.join ', '}" unless code
      code = surname_part + name_part + birthdate_part + code
      code + control_character(code)
    end

    def surname_part
      first_three_consonants_than_vowels surname
    end

    def name_part
      return "#{consonants_of_name[0]}#{consonants_of_name[2..3]}" if consonants_of_name.size >= 4
      first_three_consonants_than_vowels name
    end

    def birthdate_part
      code = birthdate.year.to_s[2..3]
      code << Codes.month_letter(birthdate.month)
      day_part = citizen.female? ? birthdate.day + 40 : birthdate.day
      code << "#{day_part}".rjust(2, '0')
    end

    def birthplace_part
      citizen.born_in_italy? && city_code || country_code
    end

    def control_character partial_fiscal_code
      numeric_value = 0
      partial_fiscal_code.split('').each_with_index do |chr, index|
        numeric_value += (index+1).even? ? Codes.even_character(chr) : Codes.odd_character(chr)
      end
      Codes.control_character numeric_value % 26
    end

    def consonants_of_name
      consonants name.upcase
    end

    def city_code
      return config.city_code.call(city_name, province_code) if config.city_code
      Codes.city city_name, province_code
    end

    def country_code
      return config.country_code.call(country_name) if config.country_code
      Codes.country country_name
    end
  end
end
module CodiceFiscale
  class FiscalCode
    include Helpers
    include Configurable

    attr_accessor :italian_citizen
    alias :citizen :italian_citizen

    delegate :name, :surname, :birthdate, :city_name, :province_code, :country_name, :to => :citizen

    def initialize italian_citizen
      @italian_citizen = italian_citizen
    end

    def calculate
      code = surname_part + name_part + birthdate_part + birthplace_part
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
      code << day_part
    end

    def day_part
      number = citizen.female? ? birthdate.day + 40 : birthdate.day
      "#{number}".rjust(2, '0')
    end

    def birthplace_part
      code = citizen.born_in_italy? && Codes.city(city_name, province_code) || Codes.country(country_name)
      raise "Cannot find a valid code for #{[country_name, city_name, province_code].compact.join ', '}" unless code
      code
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
  end
end
module CodiceFiscale
  class FiscalCode
    include StringHelper

    attr_accessor :italian_citizen
    alias :citizen :italian_citizen

    def initialize italian_citizen
      @italian_citizen = italian_citizen
    end

    def surname_part
      first_three_consonants_than_vowels citizen.surname
    end

    def name_part
      return "#{consonants_of_name[0]}#{consonants_of_name[2..3]}" if consonants_of_name.size >= 4
      first_three_consonants_than_vowels citizen.name
    end

    def consonants_of_name
      consonants citizen.name.upcase
    end
  end
end
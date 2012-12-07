module CodiceFiscale
  class FiscalCode
    include StringHelper

    attr_accessor :italian_citizen
    alias :citizen :italian_citizen

    def initialize italian_citizen
      @italian_citizen = italian_citizen
    end

    def surname_part
      surname = citizen.surname.upcase
      code = first_three_consonants surname
      code << first_three_vowels(surname)
      truncate_and_right_pad_with_three_x code
    end
  end
end
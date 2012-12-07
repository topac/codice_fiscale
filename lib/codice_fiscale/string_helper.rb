require 'codice_fiscale/alphabet'

module CodiceFiscale
  module StringHelper
    # Intersect two strings or a string and an array of characters.
    # todo - rename to intersection
    def intersects string_a, string_or_array_b
      letters_a = string_a.split ''
      letters_b = string_or_array_b.respond_to?(:split) ? string_or_array_b.split('') : string_or_array_b
      selected_letters = letters_a.select { |letter| letters_b.include? letter }
      selected_letters.join ''
    end

    def consonants string
      intersects string, Alphabet.consonants
    end

    def first_three_consonants string
      intersects(string, Alphabet.consonants)[0..2]
    end

    def first_three_vowels string
      intersects(string, Alphabet.vowels)[0..2]
    end

    def truncate_and_right_pad_with_three_x string
      string[0..2].ljust 3, 'X'
    end

    def first_three_consonants_than_vowels string
      string.upcase!
      code = first_three_consonants string
      code << first_three_vowels(string)
      truncate_and_right_pad_with_three_x code
    end
  end
end
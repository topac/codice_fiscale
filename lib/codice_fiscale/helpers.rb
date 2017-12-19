module CodiceFiscale
  module Helpers

    def multiset_intersection array_a, array_b
      array_a.select { |letter| array_b.include? letter }
    end

    def consonants string
      multiset_intersection(string.chars, Alphabet.consonants).join
    end

    def first_three_consonants string
      multiset_intersection(string.chars, Alphabet.consonants)[0..2].join
    end

    def first_three_vowels string
      multiset_intersection(string.chars, Alphabet.vowels)[0..2].join
    end

    def truncate_and_right_pad_with_three_x string
      string[0..2].ljust 3, 'X'
    end

    def first_three_consonants_than_vowels string
      upcase_string = string.upcase
      code = first_three_consonants upcase_string
      code << first_three_vowels(upcase_string)
      truncate_and_right_pad_with_three_x code
    end

  end
end

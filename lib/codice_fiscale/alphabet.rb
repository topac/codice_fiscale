module CodiceFiscale
  module Alphabet
    extend self

    def vowels
      %w[A E I O U]
    end

    def consonants
      letters - vowels
    end

    def letters
      ('A'..'Z').to_a
    end
  end
end
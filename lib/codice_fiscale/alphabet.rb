module CodiceFiscale
  module Alphabet
    extend self

    def vocals
      %w[A E I O U]
    end

    def consonants
      letters - vocals
    end

    def letters
      %w[A B C D E F G H I J K L M N O P Q R S T U V W X Y Z]
    end
  end
end
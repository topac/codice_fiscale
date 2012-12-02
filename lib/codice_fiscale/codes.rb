module CodiceFiscale
  module Codes
    extend self

    def config
      CodiceFiscale.config
    end

    def month_letter month_number
      decode = %w[A B C D E H L M P R S T]
      month_number < 0 ? nil : decode[month_number]
    end

    def city city_name, province_code
      CSV.foreach config.city_codes_csv_path do |row|
        if city_name.casecmp(row[3].strip) == 0 and province_code.casecmp(row[2].strip) == 0
          return row[0].strip.upcase
        end
      end
      nil
    end

    def country country_name
      CSV.foreach config.country_codes_csv_path do |row|
        return row[3].strip.upcase if country_name.casecmp(row[2].strip) == 0
      end
      nil
    end

    def odd_character character
      decode = {'0' => 1, '1' => 0, '2' => 5, '3' => 7, '4' => 9, '5' => 13, '6' => 15, '7' => 17, '8' => 19, '9' => 21, 'A' => 1, 'B' => 0,
      'C' => 5, 'D' => 7, 'E' => 9, 'F' => 13, 'G' => 15, 'H' => 17, 'I' => 19, 'J' => 21, 'K' => 2, 'L' => 4, 'M' => 18, 'N' => 20,
      'O' => 11, 'P' => 3, 'Q' => 6, 'R' => 8, 'S' => 12, 'T' => 14, 'U' => 16, 'V' => 10, 'W' => 22, 'X' => 25, 'Y' => 24, 'Z' => 23}
      decode[character.upcase]
    end

    def even_character character
      decode = {'0' => 0, '1' => 1, '2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6, '7' => 7, '8' => 8, '9' => 9, 'A' => 0, 'B' => 1,
        'C' => 2, 'D' => 3, 'E' => 4, 'F' => 5, 'G' => 6, 'H' => 7, 'I' => 8, 'J' => 9, 'K' => 10, 'L' => 11, 'M' => 12, 'N' => 13,
        'O' => 14, 'P' => 15, 'Q' => 16, 'R' => 17, 'S' => 18, 'T' => 19, 'U' => 20, 'V' => 21, 'W' => 22, 'X' => 23, 'Y' => 24, 'Z' => 25}
      decode[character.upcase]
    end

    def check_character number
      decode = %w[A B C D E F G H I J K L M N O P Q R S T U V W X Y Z]
      decode[number]
    end
  end
end
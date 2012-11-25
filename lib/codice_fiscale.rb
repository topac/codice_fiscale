require "rubygems"
require "date"
require "codice_fiscale/version"
require "codice_fiscale/alphabet"

module CodiceFiscale
  extend self

  def month_codes
    %w[A B C D E H L M P R S T]
  end

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

  def first_three_vocals string
    intersects(string, Alphabet.vocals)[0..2]
  end

  def truncate_and_right_pad_with_three_x string
    string[0..2].ljust 3, 'X'
  end

  def surname_part surname
    surname.upcase!
    code = first_three_consonants surname
    code << first_three_vocals(surname)
    truncate_and_right_pad_with_three_x code
  end

  def name_part name
    name.upcase!
    consonants_of_name = consonants name
    return consonants_of_name[0]+consonants_of_name[2..3] if consonants_of_name.size >= 4
    code = first_three_consonants name
    code << first_three_vocals(name)
    truncate_and_right_pad_with_three_x code
  end

  def birthdate_part birthdate, gender
    code = birthdate.year.to_s[2..3]
    code << month_codes[birthdate.month-1]
    day_part = gender == 'f' ? birthdate.day + 40 : birthdate.day
    code << "#{day_part}".rjust(2, '0')
  end
end
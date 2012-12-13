require 'spec_helper'

describe CodiceFiscale::FiscalCode do
  let(:citizen_marco_galli) { CodiceFiscale::ItalianCitizen.new :name => 'Marco', :surname => 'Galli', :gender => :male, :birthdate => Date.new(1983, 5, 3), :city_name => 'Oggiono', :province_code => 'LC' }
  let(:fiscal_code) { described_class.new citizen_marco_galli }

  describe '#surname_part' do
    it 'takes the first 3 consonants' do
      fiscal_code.surname_part.should == 'GLL'
    end

    it 'is 3 chrs long' do
      fiscal_code.surname_part.size.should == 3
    end

    context 'when surname has only 1 consonant' do
      before { fiscal_code.citizen.surname = 'oof' }

      it 'puts the vowels after the consonants' do
        fiscal_code.surname_part.should == 'FOO'
      end
    end

    context 'when surname is less than 3 chrs long' do
      before { fiscal_code.citizen.surname = 'm' }

      it 'pads with the "X" character' do
        fiscal_code.surname_part.should == 'MXX'
      end
    end
  end

  describe '#name_part' do
    it 'is 3 chrs long' do
      fiscal_code.name_part.size.should == 3
    end

    context 'when name has 4 or more consonants' do
      before { fiscal_code.citizen.name = 'danielino' }

      it 'takes the 1st the 3rd and the 4th' do
        fiscal_code.name_part.should == 'DLN'
      end
    end

    context "when name has 3 or less consonants" do
      before { fiscal_code.citizen.name = 'daniele' }

      it 'takes the first 3 consonants' do
        fiscal_code.name_part.should == 'DNL'
      end
    end

    context 'when name has 2 consonants' do
      before { fiscal_code.citizen.name = 'bar' }

      it 'puts the vowels after the consonants' do
        fiscal_code.name_part.should == 'BRA'
      end
    end

    context 'name is less than 3 chrs long' do
      before { fiscal_code.citizen.name = 'd' }

      it 'pad with the "X" character' do
        fiscal_code.name_part.should == 'DXX'
      end
    end
  end


  describe '#birthdate_part' do
    it 'start with the last 2 digit of the year' do
      fiscal_code.birthdate_part.should start_with '83'
    end

    describe 'the 3rd character' do
      before { CodiceFiscale::Codes.stub(:month_letter).and_return('X') }

      it 'is the month code' do
        fiscal_code.birthdate_part[2].should == 'X'
      end
    end

    describe 'the last 2 character' do
      context 'gender is male' do
        before { fiscal_code.citizen.gender = :male }

        it('is the birth day') { fiscal_code.birthdate_part[3..5].should == '03' }
      end

      context 'gender is female' do
        before { fiscal_code.citizen.gender = :female }

        it('is the birth day + 40') { fiscal_code.birthdate_part[3..5].should == '43' }
      end
    end


    describe '#city_code' do
      context 'the city and the provice are founded' do
        it 'returns the associated code' do
          fiscal_code.city_code.should == 'G009'
        end
      end

      context 'the city and the provice are not founded' do
        before { fiscal_code.citizen.city_name = 'Winterfell' }

        it 'returns nil' do
          fiscal_code.city_code.should be_nil
        end
      end

      context 'a block is configured to be called' do
        before { fiscal_code.config.city_code { "foo" } }

        it 'returns the result of the block execution' do
          fiscal_code.city_code.should == 'foo'
        end
      end
    end


    describe '#country_code' do
      context 'the country is Italy' do
        it 'returns nil' do
          fiscal_code.country_code.should be_nil
        end
      end

      context 'the country is not Italy' do
        before { fiscal_code.citizen.country_name = 'Francia' }

        it 'returns the associated code' do
          fiscal_code.country_code.should == 'Z110'
        end
      end

      context 'a block is configured to be called' do
        before { fiscal_code.config.country_code { "bar" } }

        it 'returns the result of the block execution' do
          fiscal_code.country_code.should == 'bar'
        end
      end
    end

    describe '#birthplace_part' do
      context 'whene the country is Italy' do
        it 'return the city_code' do
          fiscal_code.birthplace_part.should == fiscal_code.city_code
        end
      end
    end


    describe '#control_character' do
      it 'returns the expected letter' do
        fiscal_code.control_character('RSSMRA87A01A005').should == 'V'
      end
    end
  end
end
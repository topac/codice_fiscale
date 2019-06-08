require 'spec_helper'

describe CodiceFiscale::FiscalCode do
  let(:citizen_marco_galli) do
    CodiceFiscale::ItalianCitizen.new(
      :name           => 'Marco',
      :surname        => 'Galli',
      :gender         => :male,
      :birthdate      => Date.new(1983, 5, 3),
      :city_name      => 'Oggiono',
      :province_code  => 'LC'
    )
  end

  let(:fiscal_code) { described_class.new citizen_marco_galli }

  describe '#surname_part' do
    it 'takes the first 3 consonants' do
      expect(fiscal_code.surname_part).to eq 'GLL'
    end

    it 'is 3 chrs long' do
      expect(fiscal_code.surname_part.size).to eq 3
    end

    context 'when surname has only 1 consonant' do
      before { fiscal_code.citizen.surname = 'oof' }

      it 'puts the vowels after the consonants' do
        expect(fiscal_code.surname_part).to eq 'FOO'
      end
    end

    context 'when surname is less than 3 chrs long' do
      before { fiscal_code.citizen.surname = 'm' }

      it 'pads with the "X" character' do
        expect(fiscal_code.surname_part).to eq 'MXX'
      end
    end
  end

  describe '#name_part' do
    it 'is 3 chrs long' do
      expect(fiscal_code.name_part.size).to eq 3
    end

    context 'when name has 4 or more consonants' do
      before { fiscal_code.citizen.name = 'danielino' }

      it 'takes the 1st the 3rd and the 4th' do
        expect(fiscal_code.name_part).to eq 'DLN'
      end
    end

    context "when name has 3 or less consonants" do
      before { fiscal_code.citizen.name = 'daniele' }

      it 'takes the first 3 consonants' do
        expect(fiscal_code.name_part).to eq 'DNL'
      end
    end

    context 'when name has 2 consonants' do
      before { fiscal_code.citizen.name = 'bar' }

      it 'puts the vowels after the consonants' do
        expect(fiscal_code.name_part).to eq 'BRA'
      end
    end

    context 'name is less than 3 chrs long' do
      before { fiscal_code.citizen.name = 'd' }

      it 'pad with the "X" character' do
        expect(fiscal_code.name_part).to eq 'DXX'
      end
    end
  end


  describe '#birthdate_part' do
    it 'start with the last 2 digit of the year' do
      expect(fiscal_code.birthdate_part).to start_with '83'
    end

    describe 'the 3rd character' do
      before do
        allow(CodiceFiscale::Codes).to receive(:month_letter).and_return('X')
      end

      it 'is the month code' do
        expect(fiscal_code.birthdate_part[2]).to eq 'X'
      end
    end

    describe 'the last 2 character' do
      context 'gender is male' do
        before { fiscal_code.citizen.gender = :male }

        it('is the birth day') { expect(fiscal_code.birthdate_part[3..5]).to eq '03' }
      end

      context 'gender is female' do
        before { fiscal_code.citizen.gender = :female }

        it('is the birth day + 40') { expect(fiscal_code.birthdate_part[3..5]).to eq '43' }
      end
    end
  end

  describe '#birthplace_part' do
    context 'when the country is Italy' do
      before { fiscal_code.citizen.country_name = 'Italia' }

      context 'when codes are fetched using a proc' do
        before { fiscal_code.config.city_code { 'Winterfell' } }

        it 'returns the result of the city-block execution' do
          expect(fiscal_code.birthplace_part). to eq 'Winterfell'
        end
      end

      context 'when codes are fetched using csv' do
        before do
          allow(CodiceFiscale::Codes).to receive(:city).and_return('hello')
        end

        it 'returns the city code' do
          expect(fiscal_code.birthplace_part).to eq 'hello'
        end
      end
    end

    context 'when the country is not Italy' do
      before { fiscal_code.citizen.country_name = 'Francia' }

      context 'when codes are fetched using a proc' do
        before { fiscal_code.config.country_code { 'The North' } }

        it 'returns the result of the country-block execution' do
          expect(fiscal_code.birthplace_part).to eq 'The North'
        end
      end

      context 'when codes are fetched using csv' do
        before do
          allow(CodiceFiscale::Codes).to receive(:country).and_return('Middle-Earth')
        end

        it 'returns the country code' do
          expect(fiscal_code.birthplace_part).to eq 'Middle-Earth'
        end
      end
    end
  end

  describe '#control_character' do
    it 'returns the expected letter' do
      expect(fiscal_code.control_character('RSSMRA87A01A005')).to eq 'V'
    end
  end
end

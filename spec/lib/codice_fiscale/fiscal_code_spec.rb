require 'spec_helper'

describe CodiceFiscale::FiscalCode do
  let(:italian_citizen) { CodiceFiscale::ItalianCitizen.new :name => 'Marco', :surname => 'Galli', :gender => :male, :birthdate => Date.new(1983, 5, 2), :city_name => 'Oggiono', :province_code => 'LC' }
  let(:fiscal_code) { described_class.new italian_citizen }

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
end
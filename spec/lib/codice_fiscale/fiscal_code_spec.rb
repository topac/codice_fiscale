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
end
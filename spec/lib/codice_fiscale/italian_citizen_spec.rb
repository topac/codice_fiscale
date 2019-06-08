require 'spec_helper'

describe CodiceFiscale::ItalianCitizen do
  let(:marco_attributes) { {:name => 'Marco', :surname => 'Galli', :gender => :male, :birthdate => Date.new(1983, 5, 2), :city_name => 'Oggiono', :province_code => 'LC'} }
  let(:john_attributes) { {:name => 'John', :surname => 'Snow', :gender => :male, :birthdate => Date.new(1971, 9, 12), :country_name => 'Canada'} }
  let(:marco) { described_class.new marco_attributes }
  let(:john) { described_class.new john_attributes }


  describe '#initialize' do
    it 'accepts 1 attribute' do
      expect { marco }.not_to raise_error
    end

    it 'do not accepts 0 attribute' do
      expect { described_class.new }.to raise_error(ArgumentError)
    end
  end


  describe '#validations' do
    describe 'when all attributes are valid' do
      it 'is valid' do
        expect(marco).to be_valid
        expect(john).to be_valid
      end
    end

    describe 'when name is not present' do
      let(:citizen_without_name) { described_class.new marco_attributes.reject {|n| n == :name } }

      it 'is not valid' do
        citizen_without_name.valid?
        expect(citizen_without_name.errors[:name]).not_to be_empty
      end
    end

    describe 'when gender is not valid' do
      let(:citizen_with_strange_gender) { described_class.new marco_attributes.merge(:gender => :strange) }

      it 'is not valid' do
        citizen_with_strange_gender.valid?
        expect(citizen_with_strange_gender.errors[:gender]).not_to be_empty
      end
    end

    describe 'when the province code is not 2 characters long' do
      let(:citizen_with_invalid_province) { described_class.new marco_attributes.merge(:province_code => 'LECCO') }

      it 'is not valid' do
        citizen_with_invalid_province.valid?
        expect(citizen_with_invalid_province.errors[:province_code]).not_to be_empty
      end
    end

    describe 'when the bitrhdate is not valid' do
      let(:citizen_with_invalid_date) { described_class.new marco_attributes.merge(:birthdate => 'xxx') }

      it 'is not valid' do
        citizen_with_invalid_date.valid?
        expect(citizen_with_invalid_date.errors[:birthdate]).not_to be_empty
      end
    end
  end
end
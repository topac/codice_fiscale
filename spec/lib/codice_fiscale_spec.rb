require 'spec_helper'

describe CodiceFiscale do
  before do
    subject.config.city_codes_csv_path = "#{fixtures_path}/city_codes.csv"
    subject.config.country_codes_csv_path = "#{fixtures_path}/country_codes.csv"
  end

  describe '#surname_part' do
    it 'takes the first 3 consonants' do
      subject.surname_part('molteni').should == 'MLT'
    end

    it 'is 3 chrs long' do
      subject.surname_part('').size.should == 3
      subject.surname_part('foobar').size.should == 3
    end

    context 'surname has only 1 consonant' do
      it 'put the vowels after the consonants' do
        subject.surname_part('oof').should == 'FOO'
      end
    end

    context 'surname is less than 3 chrs long' do
      it 'pad with the "X" character' do
        subject.surname_part('m').should == 'MXX'
      end
    end
  end


  describe '#name_part' do
    it 'is 3 chrs long' do
      subject.name_part('').size.should == 3
      subject.name_part('foobar').size.should == 3
    end

    context 'name has 4 or more consonants' do
      it 'take the 1st the 3rd and the 4th' do
        subject.name_part('danielino').should == 'DLN'
      end
    end

    context "name has 3 or less consonants" do
      it 'take the first 3 consonants' do
        subject.name_part('daniele').should == 'DNL'
      end
    end

    context 'name has 2 consonants' do
      it 'put the vowels after the consonants' do
        subject.name_part('bar').should == 'BRA'
      end
    end

    context 'name is less than 3 chrs long' do
      it 'pad with the "X" character' do
        subject.name_part('d').should == 'DXX'
      end
    end
  end


  describe '#birthdate_part' do
    let(:birthdate) { Date.new 1987, 12, 3 }
    let(:male) { 'm' }
    let(:female) { 'f' }

    it 'start with the last 2 digit of the year' do
      subject.birthdate_part(birthdate, male).should start_with '87'
    end

    describe 'the 3rd character' do
      before { subject::Codes.stub(:month_letter).and_return('X') }

      it('is the month code') { subject.birthdate_part(birthdate, male)[2].should == 'X' }
    end

    describe 'the last 2 character' do
      context 'gender is male' do
        it('is the birth day') { subject.birthdate_part(birthdate, male)[3..5].should == '03' }
      end

      context 'gender is female' do
        it('is the birth day + 40') { subject.birthdate_part(birthdate, female)[3..5].should == '43' }
      end
    end
  end


  describe '#city_code' do
    context 'the city and the provice are founded' do
      it 'return the associated code' do
        subject.city_code('Abbadia Lariana', 'LC').should == 'A005'
      end
    end

    context 'the city and the provice are not founded' do
      it 'return nil' do
        subject.city_code('Winterfell', 'SO').should be_nil
      end
    end

    context 'a block is configured to be called' do
      before { subject.config.city_code { "foo" } }

      it 'return the result of the block execution' do
        subject.city_code('Lecco', 'LC').should == 'foo'
      end
    end
  end


  describe '#country_code' do
    context 'the country is founded' do
      it 'return the associated code' do
        subject.country_code('francia').should == 'Z110'
      end
    end

    context 'a block is configured to be called' do
      before { subject.config.country_code { "bar" } }

      it 'return the result of the block execution' do
        subject.country_code('francia').should == 'bar'
      end
    end
  end


  describe '#birthplace_part' do
    before do
      subject.config.country_code = nil
      subject.config.city_code = nil
    end

    context 'the country is Italy' do
      it 'return the city_code' do
        subject.birthplace_part('Italia', 'Abbadia Lariana', 'LC').should == 'A005'
      end
    end
  end


  describe '#check_character' do
    it 'call #Codes.check_character and return its result' do
      subject::Codes.should_receive :check_character
      subject.check_character 'ABC'
    end

    it 'call #Codes.odd_character for odd positioned chars' do
      subject::Codes.should_receive(:odd_character).exactly(2).and_return 1
      subject.check_character 'ABC'
    end

    it 'call #Codes.even_character for odd positioned chars' do
      subject::Codes.should_receive(:even_character).exactly(1).and_return 1
      subject.check_character 'ABC'
    end

    it 'works!' do
      subject.check_character('RSSMRA87A01A005').should == 'V'
    end
  end


  describe '#calculate' do
    context 'italian citizen' do
      it 'return the expected code' do
        params = {:name => 'mario', :surname => 'rossi', :gender => :male, :birthdate => Date.new(1987, 1, 1),
                  :province_code => 'lc', :city_name => 'Abbadia Lariana'}
        subject.calculate(params).should == 'RSSMRA87A01A005V'
      end
    end

    context 'return the expected code' do
      it 'work' do
        params = {:name => 'mario', :surname => 'rossi', :gender => :male, :birthdate => Date.new(1987, 1, 1), :country_name => 'Albania'}
        subject.calculate(params).should == 'RSSMRA87A01Z100H'
      end
    end
  end

  describe '#validate_calculate_params' do
    let(:mandatory_params) { {:name => 'mario', :surname => 'rossi', :gender => :male, :birthdate => Date.new(1987, 1, 1)} }

    context 'All mandatory params are correct' do
      it 'do not raise any arror' do
        lambda { subject.validate_calculate_params(mandatory_params) }.should_not raise_error
      end
    end

    context 'A mandatory parameter is missing' do
      it 'raise an error' do
        without_name = mandatory_params.reject {|p| p == :name }
        lambda { subject.validate_calculate_params(without_name) }.should raise_error
      end
    end

    context 'Gender is invalid' do
      it 'raise an error' do
        params = mandatory_params.merge :gender => :lol
        lambda { subject.validate_calculate_params(params) }.should raise_error
      end
    end

    context 'Birthdate is invalid' do
      it 'raise an error' do
        params = mandatory_params.merge :birthdate => '2000/01/01'
        lambda { subject.validate_calculate_params(params) }.should raise_error
      end
    end
  end
end
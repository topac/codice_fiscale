require 'spec_helper'

describe CodiceFiscale do
  def stub_csv_paths
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
      it 'put the vocals after the consonants' do
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
      it 'put the vocals after the consonants' do
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
      it('is the month code') { subject.birthdate_part(birthdate, male)[2].should == 'T' }
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
    before { stub_csv_paths }

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
    before { stub_csv_paths }

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
      stub_csv_paths
      subject.config.country_code = nil
      subject.config.city_code = nil
    end

    context 'the country is Italy' do
      it 'return the city_code' do
        subject.birthplace_part('Italia', 'Abbadia Lariana', 'LC').should == 'A005'
      end
    end
  end
end
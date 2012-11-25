require 'spec_helper'

describe CodiceFiscale do
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
end
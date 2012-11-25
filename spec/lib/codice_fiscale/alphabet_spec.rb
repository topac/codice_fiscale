require 'spec_helper'

describe CodiceFiscale::Alphabet do
  describe '#letters' do
    it 'is 26 long' do
      subject.letters.size.should == 26
    end

    it 'return only upcased letters' do
      subject.letters.each { |letter| letter.upcase.should == letter }
    end
  end

  describe '#consonants' do
    it 'is 21 long' do
      subject.consonants.size.should == 21
    end
  end

  describe '#vocals' do
    it 'return only upcased letters' do
      subject.letters.each { |letter| letter.upcase.should == letter }
    end
  end
end
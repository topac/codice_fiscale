require 'spec_helper'

describe CodiceFiscale::Alphabet do
  describe '#letters' do
    it 'is 26 long' do
      expect(subject.letters.size).to eq 26
    end

    it 'consists only of upcased letters' do
      expect(subject.letters.join).to match /^[A-Z]{1,}$/
    end
  end

  describe '#consonants' do
    it 'is 21 long' do
      expect(subject.consonants.size).to eq 21
    end

    it 'consists only of upcased letters' do
      expect(subject.vowels.join).to match /^[A-Z]{1,}$/
    end
  end

  describe '#vowels' do
    it 'is 5 long' do
      expect(subject.vowels.size).to eq 5
    end

    it 'consists only of upcased letters' do
      expect(subject.vowels.join).to match /^[A-Z]{1,}$/
    end
  end
end

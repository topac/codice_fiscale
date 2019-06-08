require 'spec_helper'

describe CodiceFiscale::Codes do
  describe '#month_letter' do
    context 'the given number is greater than 0 and less than 12' do
      it 'return a letter' do
        1.upto(12).each do |n|
          expect(subject.month_letter(1)).to match /^[A-Z]{1,}$/
        end
      end
    end

    context 'the given number is greater than 12' do
      it 'return nil' do
        expect(subject.month_letter(13)).to be_nil
      end
    end

    context 'the given number is less than 1' do
      it 'return nil' do
        -1.upto(0).each do |n|
          expect(subject.month_letter(n)).to be_nil
        end
      end
    end
  end
end
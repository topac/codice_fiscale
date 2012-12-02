require 'spec_helper'

describe CodiceFiscale::Codes do
  describe '#month_letter' do
    context 'the given number is greater or equal than 0 and less than 12' do
      it 'return a letter' do
        subject.month_letter(0).should == 'A'
      end
    end

    context 'the given number is greater than 11' do
      it 'return nil' do
        subject.month_letter(12).should be_nil
      end
    end

    context 'the given number is less than 0' do
      it 'return nil' do
        subject.month_letter(-1).should be_nil
      end
    end
  end
end
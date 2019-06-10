# -*- encoding: utf-8 -*-
require 'spec_helper'

describe CodiceFiscale do
  describe '#calculate' do
    before do
      subject.config.city_code = nil
      subject.config.country_code = nil
    end

    it 'returns the expected code' do
      # Please note that the following are completely made-up data
      [
        [{:name => 'mario', :surname => 'rossi', :gender => :male, :birthdate => Date.new(1987, 1, 1), :province_code => 'lc', :city_name => 'Abbadia Lariana'}, "RSSMRA87A01A005V"],
        [{:name => "Marco", :surname => "Rossi", :gender => :male, :birthdate => Date.new(1983, 5, 3), :city_name => "Oggiono", :province_code => "LC"}, "RSSMRC83E03G009W"],
        [{:name => "John", :surname => "Smith", :gender => :male, :birthdate => Date.new(1988, 5, 3), :country_name => "Francia"}, "SMTJHN88E03Z110R"],
        [{:name => "John", :surname => "Smith", :gender => :male, :birthdate => Date.new(1988, 5, 3), :country_name => "France"}, "SMTJHN88E03Z110R"],
        [{:name => "John", :surname => "Smith", :gender => :male, :birthdate => Date.new(1988, 5, 3), :country_name => "Sao Tomé e Principe"}, "SMTJHN88E03Z341A"],
        [{:name => "Marco", :surname => "Rossi", :gender => :male, :birthdate => Date.new(1983, 5, 3), :city_name => "Forlì", :province_code =>"FC"}, "RSSMRC83E03D704X"],
      ].each do |row|
        params, expected_code = row[0], row[1]
        expect(subject.calculate(params)).to eq expected_code
      end
    end

    context 'when params are not valid' do
      let(:invalid_attributes) { {:name => ''} }

      it 'raises an error' do
        expect { subject.calculate(invalid_attributes) }.to raise_error(ArgumentError)
      end
    end
  end
end

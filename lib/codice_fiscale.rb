require 'rubygems'
require 'date'
require 'csv'
require 'active_model'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/module/delegation'


%w[version configuration helpers alphabet codes italian_citizen fiscal_code].each do |filename|
  require "codice_fiscale/#{filename}"
end


module CodiceFiscale
  def self.config
    @config ||= Configuration.new
  end

  def self.calculate params
    citizen = ItalianCitizen.new params
    raise ArgumentError.new("#{citizen.errors}") unless citizen.valid?
    citizen.fiscal_code
  end
end
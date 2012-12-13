require 'rubygems'
require 'date'
require 'csv'
require 'active_model'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/module/delegation'
require 'codice_fiscale/version'
require 'codice_fiscale/alphabet'
require 'codice_fiscale/codes'
require 'codice_fiscale/configuration'
require 'codice_fiscale/helpers'
require 'codice_fiscale/fiscal_code'
require 'codice_fiscale/italian_citizen'

module CodiceFiscale
  def self.calculate params
    citizen = ItalianCitizen.new params
    raise ArgumentError.new("#{citizen.errors}") unless citizen.valid?
    citizen.fiscal_code
  end
end
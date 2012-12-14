module CodiceFiscale
  class Configuration
    def initialize
      @options = default
    end

    def csv_folder
      File.join File.dirname(__FILE__), 'codes'
    end

    def default
      {
        :city_codes_csv_path => "#{csv_folder}/city_codes.csv",
        :country_codes_csv_path => "#{csv_folder}/country_codes.csv",
        :city_code => nil,
        :country_code => nil
      }
    end

    def method_missing name, *args, &block
      name = remove_final_equal_char(name).to_sym
      return @options[name] if args.empty? and !block_given?
      @options[name] = block_given? && block || args.first
    end

    def remove_final_equal_char string
      parts = string.to_s.scan(/\A(.*)(\=)\z/).flatten
      parts.empty? ? string : parts.first
    end
  end


  module Configurable
    def self.config
      CodiceFiscale.config
    end

    def config
      Configurable.config
    end
  end
end
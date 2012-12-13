module CodiceFiscale
  class ItalianCitizen
    include ActiveModel::Validations

    MANDATORY_ATTRIBUTES = [:name, :surname, :birthdate, :gender]

    attr_accessor :city_name, :country_name, :province_code, *MANDATORY_ATTRIBUTES

    # Validations

    validates_presence_of *MANDATORY_ATTRIBUTES
    validates_inclusion_of :gender, :in => [:male, :female]
    validates_length_of :province_code, :is => 2, :allow_blank => true
    validates_presence_of :city_name, :province_code, :if => lambda{ |obj| obj.born_in_italy? }
    validate do
      errors.add(:birthdate, :invalid) unless birthdate.respond_to? :year
    end


    # Instance methods

    def initialize attributes
      @attributes = default_attributes.merge attributes
      @attributes.each { |name, value| send("#{name}=", value) }
    end

    def default_attributes
      {:country_name => Codes::ITALY}
    end

    def born_in_italy?
      Codes.italy? country_name
    end

    def female?
      gender == :female
    end

    def fiscal_code
      FiscalCode.new(self).calculate
    end

    # This method exists to support ActiveModel::Validations integration
    def read_attribute_for_validation key
      @attributes[key]
    end
  end
end
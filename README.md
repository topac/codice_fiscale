[![Gem Version](https://badge.fury.io/rb/codice-fiscale.svg)](https://badge.fury.io/rb/codice-fiscale)
[![Build Status](https://travis-ci.org/topac/codice_fiscale.svg?branch=master)](https://travis-ci.org/topac/codice_fiscale)

# Codice Fiscale (Italian Tax ID)

A Ruby gem that calculates the *Codice FIscale* (Italian Tax ID).

The *Codice FIscale* is an identifier unique to each person that is used when dealing with Italian government offices or for private concerns and is formulated using a combination of the person’s name, place and date of birth.  Usually it is attributed by the Office of Income Revenue (*Agenzia delle Entrate*) through local tax offices.

The code is 16 characters long and includes both letters and numbers, for e.g: `RSSMRA90A01H501W` (taken from [this sample card](https://i.imgur.com/UVXKDX8.png)). Read more on [wikipedia](http://en.wikipedia.org/wiki/Italian_fiscal_code_card) or [here](https://itamcap.com/italian-tax-id).


## Installation

**WARNING:** The gem name on rubygems.org is "codice-fiscale" not "codice_fiscale"

Add this line to your application's Gemfile:
```ruby
    source 'https://rubygems.org'
    gem 'codice-fiscale'
```

And then execute the `bundle install` command.

## Usage

```ruby
  require 'codice_fiscale'

  CodiceFiscale.calculate(
    :name          => 'Mario',
    :surname       => 'Rossi',
    :gender        => :male,
    :birthdate     => Date.new(1987, 1, 1),
    :province_code => 'MI',
    :city_name     => 'Milano'
  )
  # => RSSMRA87A01F205E
```

## City codes (Codici Catastali)
As explained above, one of the information required to calculate the fiscal code is the birthplace.  
If a person was born outside Italy, only the italian name of the country is required.  
For example, an italian citizen born in France:

```ruby
  CodiceFiscale.calculate(
    :name         => 'Mario', 
    :surname      => 'Rossi', 
    :gender       => :male, 
    :birthdate    => Date.new(1987, 1, 1), 
    :country_name => 'Francia'
  )
  # => RSSMRA87A01Z110I
```

If a person was born in Italy you have to specify the *code* of the province and the *name* of the city. These informations are actually contained in a CSV 
document downloaded from [istat.it](http://www.istat.it/it/archivio/6789), converted and shipped with this gem.


**But what if you have your own table with all those codes?**

In this case, you can add a custom block that fetches the codes from your database:


*config/initializers/codice_fiscale_initializer.rb*:

```ruby
  CodiceFiscale.config.country_code do |country_name|
    # Place your code here, for e.g.:
    YourCountryActiveRecordModel.find_by_name(country_name).code
    # So that given for e.g. country_name="Denmark" the returned code must be "Z107"
    # Checkout the file ./lib/codice_fiscale/codes/country_codes.csv
  end

  CodiceFiscale.config.city_code do |city_name, province_code|
    # Place your code here, for e.g.:
    YourCityActiveRecordModel.find_by_province_and_city(province_code, city_name).code
    # So that given for e.g. city_name="Fiumicino", province_code="RM" the returned code must be "M297"
    # Checkout the file ./lib/codice_fiscale/codes/city_codes.csv
  end
```


## Testing

    $ bundle exec rspec

This gem is tested with all ruby versions starting from 1.9.3.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


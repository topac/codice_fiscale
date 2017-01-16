# Codice fiscale

A ruby gem to support the calculation of the italian fiscal code ("Cofice fiscale"), 
that is an ID assigned to each italian citizen by the "Agenzia delle entrate".

To calculate the fiscal code you need the following information: name, surname, 
gender, birthdate and the birthplace. Read more on [wikipedia](http://en.wikipedia.org/wiki/Italian_fiscal_code_card).

## Usage

```ruby
  require 'codice_fiscale'

  CodiceFiscale.calculate(
    :name          => 'Mario',
    :surname       => 'Rossi', 
    :gender        => :male,
    :birthdate     => Date.new(1987, 1, 1),
    :province_code => 'LC', 
    :city_name     => 'Abbadia Lariana'
  )
  #=> RSSMRA87A01A005V
```

## City codes (Codici catastali)
As explained above, one of the information required to calculate the fiscal code is the birthplace.  
If a person was born outside Italy, only the italian name of the county is required.  
For example, an italian citizen born in France:

```ruby
  CodiceFiscale.calculate(
    :name         => 'Mario', 
    :surname      => 'Rossi', 
    :gender       => :male, 
    :birthdate    => Date.new(1987, 1, 1), 
    :country_name => 'Francia'
  )
```

If a person was born in Italy you have to specify the *code* of the province and the *name* of the city. These informations are actually contained in an XLS 
document downloaded from [istat.it](http://www.istat.it/it/archivio/6789), converted to CSV and shipped with this gem.

**But what if you have your own table with all those codes?**

In this case, you can add a custom block that fetches the codes from your tables/files:


*config/initializers/codice_fiscale_initializer.rb*:

```ruby
  # Fetching the codes using ActiveRecord:

  CodiceFiscale.config.country_code do |country_name|
    Country.find_by_name(country_name).code
  end

  CodiceFiscale.config.city_code do |city_name, province_code|
    City.in_italy.find_by_province_and_city(province_code, city_name).code
  end
```

## Installation

I'm currently supporting only **ruby 1.9+**

**Note:** The gem name on rubygems.org is "codice-fiscale" not "codice_fiscale"

Add this line to your application's Gemfile:

    gem 'codice-fiscale'

And then execute:

    $ bundle

## Testing

I'm using RSpec + guard (+ growl for notifications)

    $ bundle exec guard

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


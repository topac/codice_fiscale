# -*- encoding: utf-8 -*-
require File.expand_path('../lib/codice_fiscale/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["topac"]
  gem.email         = ["topac@users.noreply.github.com"]
  gem.description   = %q{Calculate the Italian Tax ID (Codice Fiscale)}
  gem.summary       = %q{Calculate the Italian Tax ID (Codice Fiscale)}
  gem.homepage      = "https://github.com/topac/codice_fiscale"
  gem.platform      = Gem::Platform::RUBY

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "codice-fiscale"
  gem.require_paths = ["lib"]
  gem.version       = CodiceFiscale::VERSION

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'rb-fsevent', '~> 0.9.1'

  gem.add_dependency 'activesupport'
  gem.add_dependency 'activemodel'
end
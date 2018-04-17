# -*- encoding: utf-8; mode: ruby -*-
require File.expand_path('../lib/rusk/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["tomi"]
  gem.email         = ["tomiacannondale@gmail.com"]
  gem.description   = %q{Rusk is library that read and write Open Document Spreadsheet Format(ods).}
  gem.summary       = %q{Read and write Open Document Spreadsheet Format(ods).}
  gem.homepage      = "https://github.com/tomiacannondale/rusk"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rusk"
  gem.require_paths = ["lib"]
  gem.version       = Rusk::VERSION

  gem.add_runtime_dependency 'rubyzip', '~> 1.2.1'
  gem.add_runtime_dependency 'nokogiri', '~> 1.5.8'
  gem.add_development_dependency "rake", '~> 0.9'
  gem.add_development_dependency 'rspec', '~> 2.11.0'
  gem.add_development_dependency 'rb-fsevent', '~> 0.9.0'
  gem.add_development_dependency 'listen', '~> 0.5.0'
  gem.add_development_dependency 'growl', '~> 1.0.0'
  gem.add_development_dependency "guard-rspec", '~> 2.1.0'
  gem.add_development_dependency "pry", '~> 0.9'
end

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dhl/version'

Gem::Specification.new do |spec|
  spec.name          = 'dhl'
  spec.version       = Dhl::VERSION
  spec.authors       = ['Alessandro Mencarini']
  spec.email         = ['a.mencarini@freegoweb.it']
  spec.description   = 'A wrapper for DHL SOAP interface. '
  spec.summary       = 'This gem will provide a wrapper to DHL SOAP API. Given DHL credentials and the addresses, will generate a shipping label.'
  spec.homepage      = 'http://momitians.github.io/dhl'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'savon', '~> 2.2'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 2.14.1'
  spec.add_development_dependency 'factory_girl', '~> 4.2.0'
  spec.add_development_dependency 'vcr', '~> 2.5.0'
  spec.add_development_dependency 'webmock', '~> 1.13.0'
  spec.add_development_dependency 'pry', '~> 0.9.12'
end

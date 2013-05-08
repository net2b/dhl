# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dhl/version'

Gem::Specification.new do |spec|
  spec.name          = "dhl"
  spec.version       = Dhl::VERSION
  spec.authors       = ["Alessandro Mencarini"]
  spec.email         = ["a.mencarini@freegoweb.it"]
  spec.description   = %q{A wrapper for DHL SOAP interface. }
  spec.summary       = %q{This gem will provide a wrapper to DHL SOAP API. Given DHL credentials and the addresses, will generate a shipping label.}
  spec.homepage      = "http://momitians.github.io/dhl"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "savon", "~> 2.2.0"


  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "factory_girl"
  spec.add_development_dependency "pry"
end

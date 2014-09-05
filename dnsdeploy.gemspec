# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dnsdeploy/version'

Gem::Specification.new do |spec|
  spec.name          = "dnsdeploy"
  spec.version       = Dnsdeploy::VERSION
  spec.authors       = ["beanieboi"]
  spec.email         = ["beanie@benle.de"]
  spec.summary       = %q{Wrapper between DNSimple and records.json}
  spec.description   = %q{Wrapper between DNSimple and records.json - deploy your DNS records}
  spec.homepage      = "https://www.codeship.io"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "dnsimple-ruby", "~> 1.5"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.3"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", "~> 0.10"
end

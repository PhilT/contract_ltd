# coding: utf-8
require 'base64'

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'contract_ltd/version'

Gem::Specification.new do |spec|
  spec.name          = "contract_ltd"
  spec.version       = ContractLtd::VERSION
  spec.authors       = ["Phil Thompson"]
  spec.email         = Base64.decode64("cGhpbEBlbGVjdHJpY3Zpc2lvbnMuY29t\n")

  spec.summary       = 'Generate invoices for contract work and dividend certificates'
  spec.homepage      = 'https://github.com/PhilT/contract_ltd'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'activesupport'
  spec.add_dependency 'shrimp'
  spec.add_dependency 'slim'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end


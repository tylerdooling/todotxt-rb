# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'todotxt/version'

Gem::Specification.new do |spec|
  spec.name          = "todotxt"
  spec.version       = TodoTxt::VERSION
  spec.authors       = ["Tyler Dooling"]
  spec.email         = ["me@tylerdooling.com"]
  spec.summary       = %q{A ruby library for interacting with Todo.txt formatted files.}
  spec.description   = %q{A ruby library for interacting with Todo.txt formatted files.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end

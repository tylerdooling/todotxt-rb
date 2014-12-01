# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'todotxt/version'

Gem::Specification.new do |spec|
  spec.name                  = "todotxt-rb"
  spec.version               = TodoTxt::VERSION
  spec.authors               = ["Tyler Dooling"]
  spec.email                 = ["me@tylerdooling.com"]
  spec.summary               = %q{A ruby library for interacting with Todo.txt formatted files.}
  spec.description           = %q{TodoTxt is a ruby library for interacting with Todo.txt formatted files.  It provides a simple ruby object interface for creating addons or writing new Todo.txt compatible applications. }
  spec.homepage              = "https://github.com/tylerdooling/todotxt-rb"
  spec.license               = "MIT"
  spec.required_ruby_version = '>= 1.9.3'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end

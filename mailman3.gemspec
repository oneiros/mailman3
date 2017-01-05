# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mailman3/version'

Gem::Specification.new do |spec|
  spec.name          = "mailman3"
  spec.version       = Mailman3::VERSION
  spec.authors       = ["David Roetzel"]
  spec.email         = ["david@roetzel.de"]

  spec.summary       = %q{Access (parts of) the mailman 3(.0) REST API from Ruby.}
  spec.homepage      = "https://github.com/oneiros/mailman3"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "webmock", "~> 2.3.1"

  spec.add_dependency "httparty", "~> 0.14.0"
end

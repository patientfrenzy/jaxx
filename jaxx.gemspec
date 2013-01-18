# -*- encoding: utf-8 -*-
require File.expand_path('../lib/jaxx/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Marc Watts"]
  gem.email         = ["marcky.sharky@googlemail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "jaxx"
  gem.require_paths = ["lib"]
  gem.version       = Jaxx::VERSION

  gem.add_dependency 'fog'
  gem.add_development_dependency 'guard'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'fakeweb'
end

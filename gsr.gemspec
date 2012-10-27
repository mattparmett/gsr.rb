# -*- encoding: utf-8 -*-
require File.expand_path('../lib/gsr/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = "Matt Parmett"
  gem.email         = "parm289@yahoo.com"
  gem.description   = %q{Ruby wrapper for the Wharton GSR Reservation System}
  gem.summary       = %q{Ruby wrapper for the Wharton GSR Reservation System}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "gsr"
  gem.require_paths = ["lib"]
  gem.version       = Gsr::Ruby::VERSION
  
  gem.add_dependency "mechanize"
end

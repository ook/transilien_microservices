# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'transilien/version'

Gem::Specification.new do |gem|
  gem.name          = "transilien_microservices"
  gem.version       = Transilien::VERSION
  gem.authors       = ["Thomas Lecavelier"]
  gem.email         = ["thomas-gems@lecavelier.name"]
  gem.description   = %q{Implements SNCF Transilien micro-services API: enable access to their theoric offer.}
  gem.summary       = %q{See http://test.data-sncf.com/index.php?p=transilien}
  gem.homepage      = "https://github.com/ook/transilien_microservices"
  gem.license       = 'MIT'

  gem.add_runtime_dependency('faraday',  '>= 0.8.4') # HTTP(S) connections
  gem.add_runtime_dependency('nokogiri', '>= 1.5.5') # XML parsing

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end

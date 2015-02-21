# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'thetvdb_party/version'

Gem::Specification.new do |spec|
  spec.name          = "thetvdb_party"
  spec.version       = TheTvDbParty::VERSION
  spec.authors       = ["Fredrik H\xC3\xB8is\xC3\xA6ther Rasch", "Tim Alexander Teige", "Peter Munch-Ellingsen", "Tore Skog Pettersen", "Alexander Trondsen Nordvik"]
  spec.email         = ["fredrik.rasch@gmail.com", "tim.teige91@gmail.com", "peterme@peterme.net"]
  spec.summary       = "Ruby Gem for accessing the TheTVDB programmers API"
  spec.description   = <<-EOF
    NOTE: This Gem is currently in its pre-alpha development stadium and currently only supports minimal capability.
    The thetvdb_party gem accesses the TheTvDB programmers API as it is described on \"http://thetvdb.com/wiki/index.php/Programmers_API\".
    It uses compression to minimize bandwith when accessing Full Series Records.
    EOF
  spec.license       = "MIT"
  spec.homepage      = "https://rubygems.org/gems/thetvdb_party"
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.rdoc_options << '--title' << 'thetvdb_party' <<
      '--main' << 'README.md' <<
      '--line-numbers'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"

  spec.add_dependency "httparty", "~> 0.6"
end

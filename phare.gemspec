# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'phare/version'

Gem::Specification.new do |spec|
  spec.name          = 'phare'
  spec.version       = Phare::VERSION
  spec.authors       = ['Rémi Prévost']
  spec.email         = ['rprevost@mirego.com']
  spec.description   = 'Phare looks into your files and check for (Ruby, JavaScript and SCSS) coding style errors.'
  spec.summary       = spec.description
  spec.homepage      = 'https://github.com/mirego/phare'
  spec.license       = 'BSD 3-Clause'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.0.0.rc1'
  spec.add_development_dependency 'rubocop', '0.27'
end

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dragonfly/dropbox_data_store/version'

Gem::Specification.new do |spec|
  spec.name          = "dragonfly-dropbox_data_store"
  spec.version       = Dragonfly::DropboxDataStore::VERSION
  spec.authors       = ["Daniel Leavitt"]
  spec.email         = ["daniel.leavitt@gmail.com"]
  spec.summary       = %q{Dropbox data store for Dragonfly}
  spec.description   = %q{Dragonfly plugin for storing attachments on Dropbox}
  spec.homepage      = "https://github.com/dleavitt/dragonfly-dropbox_data_store"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.0"

  spec.add_runtime_dependency "dragonfly", "~> 1.0"
  spec.add_runtime_dependency "dropbox-sdk", "~> 1.6"
end

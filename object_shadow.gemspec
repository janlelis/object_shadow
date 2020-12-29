# -*- encoding: utf-8 -*-

require File.dirname(__FILE__) + "/lib/object_shadow/version"

Gem::Specification.new do |gem|
  gem.name          = "object_shadow"
  gem.version       = ObjectShadow::VERSION
  gem.summary       = "Metaprogramming Level 2"
  gem.description   = "provides a simple convenient API for accessing an object's state."
  gem.authors       = ["Jan Lelis"]
  gem.email         = ["hi@ruby.consulting"]
  gem.homepage      = "https://github.com/janlelis/object_shadow"
  gem.license       = "MIT"

  gem.files         = Dir["{**/}{.*,*}"].select{ |path| File.file?(path) && path !~ /^pkg/ && path !~ /png\z/ }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.required_ruby_version = ">= 2.0", "< 4.0"
end

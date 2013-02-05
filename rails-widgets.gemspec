# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails/widgets/version'

Gem::Specification.new do |gem|
  gem.name          = "rails-widgets"
  gem.version       = Rails::Widgets::VERSION
  gem.authors       = ["Jared Grippe"]
  gem.email         = ["jared@deadlyicon.com"]
  gem.description   = %q{A view component system for rails}
  gem.summary       = %q{A view component system for rails}
  gem.homepage      = "http://github.com/deadlyicon/rails-widgets"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.required_rubygems_version = ">= 1.3.6"
  gem.rubyforge_project         = "jquery-rails"

  gem.add_dependency "railties", ">= 3.0", "< 5.0"

end

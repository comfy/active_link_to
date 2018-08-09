# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'active_link_to/version'

Gem::Specification.new do |s|
  s.name          = 'active_link_to'
  s.version       = ActiveLinkTo::VERSION
  s.authors       = ['Oleg Khabarov']
  s.email         = ['oleg@khabarov.ca']
  s.homepage      = 'http://github.com/comfy/active_link_to'
  s.summary       = 'ActionView helper to render currently active links'
  s.description   = 'Helpful method when you need to add some logic that figures out if the link (or more often navigation item) is selected based on the current page or other arbitrary condition'
  s.license       = 'MIT'

  s.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  s.required_ruby_version = '>= 2.3.0'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'nokogiri'
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'rake'

  s.add_dependency 'actionpack', '>= 5.0'
  s.add_dependency 'activesupport', '>= 5.0'
end

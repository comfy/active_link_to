# frozen_string_literal: true

$:.unshift File.expand_path('lib', __dir__)
require 'simple_active_link_to/version'

Gem::Specification.new do |s|
  s.name          = 'simple_active_link_to'
  s.version       = SimpleActiveLinkTo::VERSION
  s.authors       = ['Fajarullah']
  s.email         = ['frullah12@gmail.com']
  s.homepage      = 'http://github.com/frullah/simple_active_link_to'
  s.summary       = 'ActionView helper to render currently active links'
  s.description   = 'Helpful method when you need to add some logic that figures out if the link (or more often navigation item) is selected based on the current page or other arbitrary condition'
  s.license       = 'MIT'

  s.files         = `git ls-files`.split("\n")

  s.required_ruby_version = '>= 2.4.0'

  s.add_dependency 'actionpack', '>= 5.0'
  s.add_dependency 'activesupport', '>= 5.0'
end

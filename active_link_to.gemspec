# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'active_link_to/version'

Gem::Specification.new do |s|
  s.name          = "active_link_to"
  s.version       = ActiveLinkTo::VERSION
  s.authors       = ["Oleg Khabarov"]
  s.email         = ["oleg@khabarov.ca"]
  s.homepage      = "http://github.com/comfy/active_link_to"
  s.summary       = "ActionView helper to render currently active links"
  s.description   = "Helpful method when you need to add some logic that figures out if the link (or more often navigation item) is selected based on the current page or other arbitrary condition"
  s.license       = "MIT"

  s.files         = `git ls-files`.split("\n")

  s.required_ruby_version = ">= 2.3.0"

  s.add_dependency 'actionpack'
  s.add_dependency 'addressable'
end

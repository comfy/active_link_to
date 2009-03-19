require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('active_link_helper', '1.0.2') do |p|
  p.description     = "Easily manage currently active links"
  p.url             = "http://theworkinggroup.ca"
  p.author          = "Oleg Khabarov"
  p.email           = "oleg@theworkinggroup.ca"
  p.ignore_pattern  = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each{|ext| load ext}
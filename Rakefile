require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name        = 'active_link_to'
    gem.summary     = 'Marks currently active links'
    gem.description = 'Extremely helpful when you need to add some logic that figures out if the link (or more often navigation item) is selected based on the current page or other arbitrary condition'
    gem.email       = 'oleg@theworkinggroup.ca'
    gem.homepage    = 'http://github.com/twg/active_link_to'
    gem.authors     = ['Oleg Khabarov']
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :test    => :check_dependencies
task :default => :test
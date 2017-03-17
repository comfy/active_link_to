require 'rubygems'
require 'rake/testtask'
require 'bundler/setup'

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task default: :test
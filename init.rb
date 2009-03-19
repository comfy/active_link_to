begin
  require File.dirname(__FILE__) << "/lib/active_link_helper"
rescue LoadError
  require 'active_link_helper'
end
require 'rubygems'
require 'test/unit'
require 'action_controller'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'active_link_to'

# need this to simulate requests that drive active_link_helper
module FakeRequest
  class Request
    attr_accessor :fullpath
  end
  def request
    @request ||= Request.new
  end
  def params
    @params ||= {}
  end
end

ActiveLinkTo.send :include, FakeRequest

class Test::Unit::TestCase
  
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActiveLinkTo
  
end

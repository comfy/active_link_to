require 'rubygems'
require 'minitest/autorun'
require 'uri'
require 'action_view'

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

class MiniTest::Test

  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActiveLinkTo

  def assert_html(html, selector, value = nil)
    doc = Nokogiri::HTML(html)
    element = doc.at_css(selector)
    assert element, "No element found at: `#{selector}`"
    assert_equal value, element.text if value
  end

end

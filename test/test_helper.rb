require 'bundler/setup'
require 'minitest/autorun'
require 'uri'
require 'action_view'
require 'active_link_to'

class MiniTest::Test

  # need this to simulate requests that drive active_link_helper
  module FakeRequest
    class Request
      attr_accessor :original_fullpath
    end
    def request
      @request ||= Request.new
    end
    def params
      @params ||= {}
    end
  end

  ActiveLinkTo.send :include, FakeRequest

  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActiveLinkTo

  def set_path(path, purge_cache = true)
    request.original_fullpath = path
    if purge_cache && defined?(@is_active_link)
      remove_instance_variable(:@is_active_link)
    end
  end

  def assert_html(html, selector, value = nil)
    doc = Nokogiri::HTML(html)
    element = doc.at_css(selector)
    assert element, "No element found at: `#{selector}`"
    assert_equal value, element.text if value
  end
end

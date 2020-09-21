# frozen_string_literal: true

require 'bundler/setup'
require 'minitest/autorun'
require 'uri'
require 'action_view'
require 'simple_active_link_to'

class MiniTest::Test
  # need this to simulate requests that drive active_link_helper
  module FakeRequest
    class Request
      attr_accessor :original_fullpath

      def path
        return original_fullpath unless original_fullpath&.include?('?')

        @path ||= original_fullpath.split('?').first
      end
    end

    def request
      @request ||= Request.new
    end

    def params
      @params ||= {}
    end
  end

  module FakeCapture
    def capture
      yield
    end
  end

  SimpleActiveLinkTo.include FakeRequest
  SimpleActiveLinkTo.include FakeCapture

  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include SimpleActiveLinkTo

  def set_path(path, purge_cache = true)
    request.original_fullpath = path
    remove_instance_variable(:@is_active_link) if purge_cache && defined?(@is_active_link)
  end

  def assert_html(html, selector, value = nil)
    doc = Nokogiri::HTML(html)
    element = doc.at_css(selector)
    assert element, "No element found at: `#{selector}`"
    assert_equal value, element.text if value
  end
end

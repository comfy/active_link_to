# frozen_string_literal: true

require "bundler/setup"
Bundler.setup

require "rspec-html-matchers"

require "action_view"
require "active_link_to"

# Fake request object that is used in our tests
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

  def current_path_is(path, purge_cache: true)
    request.original_fullpath = path

    # method is cached, so we bust it to set path multiple times in one test
    return unless purge_cache && defined?(@is_active_link)

    remove_instance_variable(:@is_active_link)
  end
end

ActiveLinkTo.include FakeRequest

RSpec.configure do |config|
  config.include ActionView::Helpers::UrlHelper
  config.include ActionView::Helpers::TagHelper
  config.include RSpecHtmlMatchers
  config.include ActiveLinkTo
end

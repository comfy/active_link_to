# frozen_string_literal: true

# Instead of explicitly passing options to the active_link_to, you can create
# an initializer like `config/initializers/active_link_to.rb` with:
#
#   ActiveLinkTo.configure do |config|
#     config.class_active = "is-active"
#   end
#
module ActiveLinkTo
  class Configuration
    attr_accessor :class_active, :class_inactive, :active_disable, :wrap_tag, :wrap_class

    def initialize
      @class_active   = "active"
      @class_inactive = ""
      @active_disable = false
      @wrap_tag       = nil
      @wrap_class     = ""
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configuration=(config)
    @configuration = config
  end

  def self.configure
    yield configuration
  end
end

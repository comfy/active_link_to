module ActiveLinkTo
  class Configuration
    attr_accessor :class_active, :class_inactive, :active_disable, :wrap_tag, :wrap_class

    def initialize
      @class_active = 'active'.freeze
      @class_inactive = ''.freeze
      @active_disable = false
      @wrap_tag = nil
      @wrap_class = ''.freeze
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

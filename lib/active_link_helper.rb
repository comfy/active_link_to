module ActiveLinkHelper
  
  def active_link(label, link, value = nil, options = { })
    options[:class] ||= ''
    options[:class] += active_class(link, value)
    options.delete(:class) if options[:class].empty?
    link_to(content_tag(:span, label), link, options)
  end
  
  def is_active_link?(link, value = nil)
    link.gsub!(/^(https?:\/\/).*?\//, '/')
    link = link.to_s.split('?').first.to_s
    case value
    when :self:
      regex = /^#{Regexp.escape(link)}(\/?.*)?/
    when :self_only:
      regex = /^#{Regexp.escape(link)}\/?(\?.*)?$/
    when TrueClass
      return true
    when FalseClass
      return false
    when Hash
      value.each do |controller, actions|
        return true if (controller == params[:controller] && [actions].flatten.member?(params[:action]))
      end
      return false
    end
    
    if (regex and request.request_uri.match(regex))
      return true
    else
      return false
    end
  end
  
  def active_class(link, value = nil)
    is_active_link?(link, value) ? ' active' : ''
  end
end

ActionView::Base.send :include, ActiveLinkHelper
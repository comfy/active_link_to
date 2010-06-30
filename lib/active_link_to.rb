module ActiveLinkTo
  
  # Creates a link tag of the given +name+ using a URL created by the set of
  # +options+. Please see documentation for link_to, as active_link_to is
  # basically a wrapper for it. This method accepts an optional +:active+
  # parameter that dictates if the given link will have an extra css class
  # attached that marks it as 'active'.
  #
  # === Super Simple Example
  # Here's a link that will have class attached if it happens to be rendered 
  # on page with path /people or any child of that page like /people/123
  # 
  #   active_link_to 'People', '/people'
  #   # => <a href="/people" class="active">People</a>
  #
  # This is exactly the same as:
  #
  #   active_link_to 'People', '/people', :active => { :when => :self }
  #   # => <a href="/people" class="active">People</a>
  #
  # === Options
  # Here's available options that can be inserted into :active hash
  # * <tt>:when => predefined symbol || Regexp || Array tuple of controller/actions || Boolean</tt> - This controls
  #   when link is considered to be 'active'
  # * <tt>:active_class => 'class_name'</tt> - When link is 'active', css
  #   class of that link is set to the default 'active'. This parameter 
  #   allows it to be changed
  # * <tt>:inactive_class => 'class_name'</tt> - Opposite of the :active_class
  #   By default it's blank. However you can change it to whatever you want.
  # * <tt>:disable_link => Boolean</tt> - When link is active, sometimes you
  #   want to render span tag instead of the link. This parameter is for that.
  #
  # === Examples
  # Most of the functionality of active_link_helper depends on the current
  # url. Specifically, request.request_uri value. We covered the basic example
  # already, so let's try sometihng more fun
  # 
  # We want to highlight the link that matches immidiate url, and not the children
  # nodes as well
  #
  #   # For URL: /people/24
  #   active_link_to 'People', people_path, :active => { :when => :self_only }
  #   # => <a href="/people">People</a>
  #
  #   # For URL: /people
  #   active_link_to 'People', people_path, :active => { :when => :self_only }
  #   # => <a href="/people" class="active">People</a>
  #
  # If we need to set link to be active based on some regular expression, we can do
  # that as well. Let's try to activate links urls of which begin with 'peop':
  # 
  #   # For URL: /people/44
  #   active_link_to 'People', people_path, :active => { :when => /^peop/ }
  #   # => <a href="/people" class="active">People</a>
  # 
  #   # For URL: /aliens/9
  #   active_link_to 'People', people_path, :active => { :when => /^peop/ }
  #   # => <a href="/people">People</a>
  #
  # What if we need to mark link active for all URLs that match a particular controller,
  # or action, or both? Or any number of those at the same time? Sure, why not:
  #
  #   # For URL: /people/56/edit
  #   # For matching multiple controllers and actions:
  #   active_link_to 'Person Edit', edit_person_path(@person), :active => {
  #     :when => [['people', 'aliens'], ['show', 'edit']]
  #   }
  #
  #   # for matching all actions under given controllers:
  #   active_link_to 'Person Edit', edit_person_path(@person), :active => {
  #     :when => [['people', 'aliens'], []]
  #   }
  #
  #   # for matching all controllers for a particular action
  #   active_link_to 'Person Edit', edit_person_path(@person), :active => {
  #     :when => [[], ['edit']]
  #   }
  #   # => <a href="/people" class="active">People</a>
  #
  # Sometimes it should be easy as setting a true or false:
  #
  #   active_link_to 'People', people_path, :active => { :when => true }
  #   # => <a href="/people" class="active">People</a>
  #
  #   active_link_to 'People', people_path, :active => { :when => false }
  #   # => <a href="/people">People</a>
  #
  # Lets see what happens when we push some css class modifier parameters
  #
  #   # For URL: /people/12
  #   active_link_to 'People', people_path, :active => { :active_link => 'awesome_selected' }
  #   # => <a href="/people" class="awesome_selected">People</a>
  #
  #   active_link_to 'Aliens', aliens_path, :active => { :inactive_link => 'bummer_inactive' }
  #   # => <a href="/aliens" class="bummer_inactive">Aliens</a>
  #
  # Some wierd people think that link should change to a span if it indicated current page:
  #
  #   # For URL: /people
  #   active_link_to 'People', people_path, :active => { :disable_link => true }
  #   # => <span class="active">People</span>
  #   
  def active_link_to(*args, &block)
    if block_given?
      name          = capture(&block)
      options       = args[0] || {}
      html_options  = args[1] || {}
    else
      name          = args[0]
      options       = args[1] || {}
      html_options  = args[2] || {}
    end
    
    options = options.clone
    html_options = html_options.clone
    
    url = url_for(options)
    active_link_options = html_options.delete(:active) || {}
    css_class = active_class(url, active_link_options)
    
    html_options[:class] ||= ''
    html_options[:class] += " #{css_class}" if !css_class.blank?
    html_options[:class].blank? ? html_options.delete(:class) : html_options[:class].lstrip!
    
    if active_link_options[:disable_link] === true
      content_tag(:span, name, html_options)
    else
      link_to(name, url, html_options)
    end
  end
  
  # Returns css class name. Takes the link's URL and :active paramers
  def active_class(url, options = {})
    if is_active_link?(url, options)
      options[:active_class] || 'active'
    else
      options[:inactive_class] || ''
    end
  end
  
  # Returns true or false. Takes the link's URL and :active parameters
  def is_active_link?(url, options = {})
    case options[:when]
    when :self, nil
      !request.fullpath.match(/^#{Regexp.escape(url)}(\/?.*)?$/).blank?
    when :self_only
      !request.fullpath.match(/^#{Regexp.escape(url)}\/?(\?.*)?$/).blank?
    when Regexp
      !request.fullpath.match(options[:when]).blank?
    when Array
      controllers = options[:when][0]
      actions     = options[:when][1]
      (controllers.blank? || controllers.member?(params[:controller])) &&
      (actions.blank? || actions.member?(params[:action]))
    when TrueClass
      true
    when FalseClass
      false
    end
  end
  
end

ActionView::Base.send :include, ActiveLinkTo
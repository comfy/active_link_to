active\_link\_to
================

Creates a link tag of the given name using a URL created by the set of options. Please see documentation for `link_to`, as `active_link_to` is basically a wrapper for it. This method accepts an optional :active parameter that dictates if the given link will have an extra css class attached that marks it as 'active'.

## Install

When installing for Rails 3 applications add this to the Gemfile: `gem 'active_link_to'` and run `bundle install`.

For older Rails apps add `config.gem 'active_link_to'` in config/environment.rb and run `rake gems:install`. Or just checkout this repo into /vendor/plugins directory.

## Super Simple Example
Here's a link that will have class attached if it happens to be rendered 
on page with path `/users` or any child of that page like `/users/123`

    active_link_to 'Users', '/users'
    # => <a href="/users" class="active">Users</a>

This is exactly the same as:

    active_link_to 'Users', '/users', :active => :inclusive
    # => <a href="/users" class="active">Users</a>

## Active Options
Here's available options that can be used as the `:active` value

* Boolean                 -> true | false
* Symbol                  -> :exclusive | :inclusive
* Regex                   -> /regex/
* Controller/Action Pair  -> [[:controller], [:action\_a, :action\_b]]

## More Examples
Most of the functionality of `active_link_to` depends on the current
url. Specifically, `request.fullpath` value. We covered the basic example
already, so let's try something more fun.

We want to highlight the link that matches immediate url, and not the children
nodes as well
    
    # For URL: /users will be active
    active_link_to 'Users', users_path, :active => :exclusive
    # => <a href="/users" class="active">Users</a>
    
    # But for URL: /users/123 it will not be active
    active_link_to 'Users', users_path, :active => :exclusive
    # => <a href="/users">Users</a>
    
If we need to set link to be active based on some regular expression, we can do
that as well. Let's try to activate links urls of which begin with 'use':
    
    active_link_to 'Users', users_path, :active => /^\/use/
    
What if we need to mark link active for all URLs that match a particular controller,
or action, or both? Or any number of those at the same time? Sure, why not:
    
    # For matching multiple controllers and actions:
    active_link_to 'User Edit', edit_user_path(@user), :active => [['people', 'news'], ['show', 'edit']]
    
    # for matching all actions under given controllers:
    active_link_to 'User Edit', edit_user_path(@user), :active => [['people', 'news'], []]
    
    # for matching all controllers for a particular action
    active_link_to 'User Edit', edit_user_path(@user), :active => [[], ['edit']]
    
Sometimes it should be easy as setting a true or false:
    
    active_link_to 'Users', users_path, :active => true
    
## More Options
You can specify active and inactive css classes for links:
    
    active_link_to 'Users', users_path, :class_active => 'enabled'
    # => <a href="/users" class="enabled">Users</a>
    
    active_link_to 'News', news_path, :class_inactive => 'disabled'
    # => <a href="/news" class="disabled">News</a>
    
Sometimes you want to replace link with a span if it's active:
    
    active_link_to 'Users', users_path, :disable_active => true
    # => <span class="active">Users</span>
    
If you are constructing navigation links it's helpful to wrap links in another tag, like `<li>` maybe:
    
    active_link_to 'Users', users_path, :wrap_link => :li
    # => <li class="active"><a href="/users">Users</a></li>
    
## Helper Methods
You may directly use methods that `active_link_to` relies on. 

`is_active_link?` will return true or false based on the URL and value of the `:active` parameter:
    
    is_active_link?(users_path, :inclusive)
    # => true
    
`active_link_to_class` will return the css class:
    
    active_link_to_class(users_path, :active => :inclusive)
    # => 'active'

### Copyright

Copyright (c) 2009 Oleg Khabarov, The Working Group Inc. See LICENSE for details.

# active_link_to [![Gem Version](https://badge.fury.io/rb/active_link_to.png)](http://rubygems.org/gems/active_link_to) [![Build Status](https://travis-ci.org/comfy/active_link_to.png)](https://travis-ci.org/comfy/active_link_to)
Creates a link tag of the given name using a URL created by the set of options. Please see documentation for [link_to](http://api.rubyonrails.org/classes/ActionView/Helpers/UrlHelper.html#method-i-link_to), as `active_link_to` is basically a wrapper for it. This method accepts an optional :active parameter that dictates if the given link will have an extra css class attached that marks it as 'active'.

## Install
When installing for Rails 3 applications add this to the Gemfile: `gem 'active_link_to'` and run `bundle install`.

For older Rails apps add `config.gem 'active_link_to'` in config/environment.rb and run `rake gems:install`. Or just checkout this repo into /vendor/plugins directory.

## Super Simple Example
Here's a link that will have a class attached if it happens to be rendered 
on page with path `/users` or any child of that page, like `/users/123`

```ruby
active_link_to 'Users', '/users'
# => <a href="/users" class="active">Users</a>
```

This is exactly the same as:

```ruby
active_link_to 'Users', '/users', :active => :inclusive
# => <a href="/users" class="active">Users</a>
```

## Wrapper

Use `:wrap_tag` and `:wrap_tag_class` options to add a wrapper to the active link.

For example,

```ruby
active_link_to members_path, :wrap_tag => :li, :wrap_tag_class => "menu-item", :class => "menu-item-label", :active => :exclusive do %>
  "Employees"
end
```

generates:

```html
<li class="menu-item active">
  <a class="menu-item-label" href="/members">
    Employees
  </a>
</li>
```

Please note that the `active` class is added to the wrapper, instead of the link.


## Active Options
Here's a list of available options that can be used as the `:active` value

```
* Boolean                 -> true | false
* Symbol                  -> :exclusive | :inclusive
* Regex                   -> /regex/
* Controller/Action Pair  -> [[:controller], [:action_a, :action_b]]
```

## More Examples
Most of the functionality of `active_link_to` depends on the current
url. Specifically, `request.fullpath` value. We covered the basic example
already, so let's try something more fun.

We want to highlight a link that matches immediate url, but not the children
nodes. Most commonly used for 'home' links.
   
```ruby 
# For URL: /users will be active
active_link_to 'Users', users_path, :active => :exclusive
# => <a href="/users" class="active">Users</a>
```

```ruby
# But for URL: /users/123 it will not be active
active_link_to 'Users', users_path, :active => :exclusive
# => <a href="/users">Users</a>
```
    
If we need to set link to be active based on some regular expression, we can do
that as well. Let's try to activate links urls of which begin with 'use':

```ruby
active_link_to 'Users', users_path, :active => /^\/use/
```
    
What if we need to mark link active for all URLs that match a particular controller,
or action, or both? Or any number of those at the same time? Sure, why not:
   
```ruby 
# For matching multiple controllers and actions:
active_link_to 'User Edit', edit_user_path(@user), :active => [['people', 'news'], ['show', 'edit']]

# for matching all actions under given controllers:
active_link_to 'User Edit', edit_user_path(@user), :active => [['people', 'news'], []]

# for matching all controllers for a particular action
active_link_to 'User Edit', edit_user_path(@user), :active => [[], ['edit']]
```
    
Sometimes it should be as easy as giving link true or false value:

```ruby
active_link_to 'Users', users_path, :active => true
```
    
## More Options
You can specify active and inactive css classes for links:

```ruby
active_link_to 'Users', users_path, :class_active => 'enabled'
# => <a href="/users" class="enabled">Users</a>

active_link_to 'News', news_path, :class_inactive => 'disabled'
# => <a href="/news" class="disabled">News</a>
```
    
Sometimes you want to replace link tag with a span if it's active:

```ruby
active_link_to 'Users', users_path, :active_disable => true
# => <span class="active">Users</span>
```

If you are constructing navigation menu it might be helpful to wrap links in another tag, like `<li>`:

```ruby
active_link_to 'Users', users_path, :wrap_tag => :li
# => <li class="active"><a href="/users">Users</a></li>
```
    
## Helper Methods
You may directly use methods that `active_link_to` relies on. 

`is_active_link?` will return true or false based on the URL and value of the `:active` parameter:
    
```ruby
is_active_link?(users_path, :inclusive)
# => true
```
    
`active_link_to_class` will return the css class:
    
```
active_link_to_class(users_path, :active => :inclusive)
# => 'active'
```

### Copyright

Copyright (c) 2009-14 Oleg Khabarov, The Working Group Inc. See LICENSE for details.

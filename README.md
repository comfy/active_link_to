# simple_active_link_to

`simple_active_link_to` is a wrapper for [link_to](http://api.rubyonrails.org/classes/ActionView/Helpers/UrlHelper.html#method-i-link_to), with active state by adding an extra css class `active` by default.

This gem works like [active_link_to](https://github.com/comfy/active_link_to), but with additional ```active_disable``` option and without wrap tag.

[![Gem Version](https://img.shields.io/gem/v/simple_active_link_to.svg?style=flat)](http://rubygems.org/gems/simple_active_link_to)
[![Gem Downloads](https://img.shields.io/gem/dt/simple_active_link_to.svg?style=flat)](http://rubygems.org/gems/simple_active_link_to)

Tested with ruby 2.5 to 2.7 and rails 5.0 to 6.1

## Installation
add `gem 'simple_active_link_to'` to Gemfile and run `bundle install`.

or if you want to add with bundle command

`bundle add simple_active_link_to`

## Super Simple Example
Here's a link that will have a class attached if it happens to be rendered
on page with path `/users` or any child of that page, like `/users/123`

```ruby
simple_active_link_to 'Users', '/users'
# => <a href="/users" class="active">Users</a>
```

This is exactly the same as:

```ruby
simple_active_link_to 'Users', '/users', active: :inclusive
# => <a href="/users" class="active">Users</a>
```

## Active Options
Here's a list of available options that can be used as the `:active` value

```
* Boolean                         -> true | false
* Symbol                          -> :exclusive | :inclusive | :exact
* Regex                           -> /regex/
* Controller/Action Pair          -> [[:controller], [:action_a, :action_b]]
* Controller/Specific Action Pair -> [controller: :action_a, controller_b: :action_b]
* Hash                            -> { param_a: 1, param_b: 2 }
```

## More Examples
Most of the functionality of `simple_active_link_to` depends on the current
url. Specifically, `request.original_fullpath` value. We covered the basic example
already, so let's try something more fun.

We want to highlight a link that matches immediate url, but not the children
nodes. Most commonly used for 'home' links.

```ruby
# For URL: /users will be active
simple_active_link_to 'Users', users_path, active: :exclusive
# => <a href="/users" class="active">Users</a>
```

```ruby
# But for URL: /users/123 it will not be active
simple_active_link_to 'Users', users_path, active: :exclusive
# => <a href="/users">Users</a>
```

If we need to set link to be active based on some regular expression, we can do
that as well. Let's try to activate links urls of which begin with 'use':

```ruby
simple_active_link_to 'Users', users_path, active: /^\/use/
```

If we need to set link to be active based on an exact match, for example on
filter made via a query string, we can do that as well:

```ruby
simple_active_link_to 'Users', users_path(role_eq: 'admin'), active: :exact
```

What if we need to mark link active for all URLs that match a particular controller,
or action, or both? Or any number of those at the same time? Sure, why not:

```ruby
# For matching multiple controllers and actions:
simple_active_link_to 'User Edit', edit_user_path(@user), active: [['people', 'news'], ['show', 'edit']]

# For matching specific controllers and actions:
simple_active_link_to 'User Edit', edit_user_path(@user), active: [people: :show, news: :edit]

# for matching all actions under given controllers:
simple_active_link_to 'User Edit', edit_user_path(@user), active: [['people', 'news'], []]

# for matching all controllers for a particular action
simple_active_link_to 'User Edit', edit_user_path(@user), active: [[], ['edit']]
```

Sometimes it should be as easy as giving link true or false value:

```ruby
simple_active_link_to 'Users', users_path, active: true
```

If we need to set link to be active based on `params`, we can do that as well:

```ruby
simple_active_link_to 'Admin users', users_path(role_eq: 'admin'), active: { role_eq: 'admin' }
```

## More Options
You can specify active and inactive css classes for links:

```ruby
simple_active_link_to 'Users', users_path, class_active: 'enabled'
# => <a href="/users" class="enabled">Users</a>

simple_active_link_to 'News', news_path, class_inactive: 'disabled'
# => <a href="/news" class="disabled">News</a>
```

Sometimes you want to replace link tag with a span if it's active:

```ruby
simple_active_link_to 'Users', users_path, active_disable: true
# => <span class="active">Users</span>
```

or you want to append it with hash (`#`) at the end of url, it will be useful when you use Turbolinks
and don't want the link load the page content

```ruby
simple_active_link_to 'Users', users_path, active_disable: :hash
# => <a href="/users" class="active">Users</a>
```

## Helper Methods
You may directly use methods that `simple_active_link_to` relies on.

`is_active_link?` will return true or false based on the URL and value of the `:active` parameter:

```ruby
is_active_link?(users_path, :inclusive)
# => true
```

`active_link_to_class` will return the css class:

```
active_link_to_class(users_path, active: :inclusive)
# => 'active'
```

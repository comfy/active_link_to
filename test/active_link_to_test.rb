require_relative 'test_helper'

class ActiveLinkToTest < MiniTest::Test

  def test_is_active_link_booleans_test
    assert is_active_link?('/', true)
    assert !is_active_link?('/', false)
  end

  def test_is_active_link_symbol_inclusive
    request.fullpath = '/root'
    assert is_active_link?('/root', :inclusive)

    request.fullpath = '/root?param=test'
    assert is_active_link?('/root', :inclusive)

    request.fullpath = '/root/child/sub-child'
    assert is_active_link?('/root', :inclusive)

    request.fullpath = '/other'
    assert !is_active_link?('/root', :inclusive)
  end

  def test_is_active_link_symbol_inclusive_implied
    request.fullpath = '/root/child/sub-child'
    assert is_active_link?('/root')
  end

  def test_is_active_link_symbol_inclusive_similar_path
    request.fullpath = '/root/abc'
    assert !is_active_link?('/root/a', :inclusive)
  end

  def test_is_active_link_symbol_inclusive_with_last_slash
    request.fullpath = '/root/abc'
    assert is_active_link?('/root/')
  end

  def test_is_active_link_symbol_inclusive_with_last_slash_and_similar_path
    request.fullpath = '/root_path'
    assert !is_active_link?('/root/')
  end

  def test_is_active_link_symbol_inclusive_with_link_params
    request.fullpath = '/root?param=test'
    assert is_active_link?('/root?attr=example')
  end

  def test_is_active_link_symbol_exclusive
    request.fullpath = '/root'
    assert is_active_link?('/root', :exclusive)

    request.fullpath = '/root?param=test'
    assert is_active_link?('/root', :exclusive)

    request.fullpath = '/root/child'
    assert !is_active_link?('/root', :exclusive)
  end

  def test_is_active_link_symbol_exclusive_with_link_params
    request.fullpath = '/root?param=test'
    assert is_active_link?('/root?attr=example', :exclusive)
  end

  def test_is_active_link_symbol_exact
    request.fullpath = '/root?param=test'
    assert is_active_link?('/root?param=test', :exact)

    request.fullpath = '/root?param=test'
    refute is_active_link?('/root?param=exact', :exact)

    request.fullpath = '/root'
    refute is_active_link?('/root?param=test', :exact)

    request.fullpath = '/root?param=test'
    refute is_active_link?('/root', :exact)
  end

  def test_is_active_link_regex
    request.fullpath = '/root'
    assert is_active_link?('/', /^\/root/)

    request.fullpath = '/root/child'
    assert is_active_link?('/', /^\/r/)

    request.fullpath = '/other'
    assert !is_active_link?('/', /^\/r/)
  end

  def test_is_active_link_array
    params[:controller], params[:action] = 'controller', 'action'

    assert is_active_link?('/', [['controller'], ['action']])
    assert is_active_link?('/', [['controller'], ['action', 'action_b']])
    assert is_active_link?('/', [['controller', 'controller_b'], ['action']])
    assert is_active_link?('/', [['controller', 'controller_b'], ['action', 'action_b']])
    assert is_active_link?('/', ['controller', 'action'])
    assert is_active_link?('/', ['controller', ['action', 'action_b']])
    assert is_active_link?('/', [['controller', 'controller_b'], 'action'])

    assert !is_active_link?('/', ['controller_a', 'action'])
    assert !is_active_link?('/', ['controller', 'action_a'])
  end

  def test_is_active_link_hash
    params[:a] = 1

    assert is_active_link?('/', {:a => 1})
    assert is_active_link?('/', {:a => 1, :b => nil})

    assert !is_active_link?('/', {:a => 1, :b => 2})
    assert !is_active_link?('/', {:a => 2})

    params[:b] = 2

    assert is_active_link?('/', {:a => 1, :b => 2})
    assert is_active_link?('/', {:a => 1, :b => 2, :c => nil})

    assert is_active_link?('/', {:a => 1})
    assert is_active_link?('/', {:b => 2})
  end

  def test_active_link_to_class
    request.fullpath = '/root'
    assert_equal 'active', active_link_to_class('/root')
    assert_equal 'on', active_link_to_class('/root', :class_active => 'on')

    assert_equal '', active_link_to_class('/other')
    assert_equal 'off', active_link_to_class('/other', :class_inactive => 'off')
  end

  def test_active_link_to
    request.fullpath = '/root'
    link = active_link_to('label', '/root')
    assert_html link, 'a.active[href="/root"]', 'label'

    link = active_link_to('label', '/other')
    assert_html link, 'a[href="/other"]', 'label'
  end

  def test_active_link_to_with_existing_class
    request.fullpath = '/root'
    link = active_link_to('label', '/root', :class => 'current')
    assert_html link, 'a.current.active[href="/root"]', 'label'

    link = active_link_to('label', '/other', :class => 'current')
    assert_html link, 'a.current[href="/other"]', 'label'
  end

  def test_active_link_to_with_custom_classes
    request.fullpath = '/root'
    link = active_link_to('label', '/root', :class_active => 'on')
    assert_html link, 'a.on[href="/root"]', 'label'

    link = active_link_to('label', '/other', :class_inactive => 'off')
    assert_html link, 'a.off[href="/other"]', 'label'
  end

  def test_active_link_to_with_wrap_tag
    request.fullpath = '/root'
    link = active_link_to('label', '/root', :wrap_tag => :li)
    assert_html link, 'li.active a.active[href="/root"]', 'label'

    link = active_link_to('label', '/root', :wrap_tag => :li, :active_disable => true)
    assert_html link, 'li.active span.active', 'label'

    link = active_link_to('label', '/root', :wrap_tag => :li, :class => 'testing')
    assert_html link, 'li.testing.active a.testing.active[href="/root"]', 'label'
  end

  def test_active_link_to_with_active_disable
    request.fullpath = '/root'
    link = active_link_to('label', '/root', :active_disable => true)
    assert_html link, 'span.active', 'label'
  end

  def test_should_not_modify_passed_params
    request.fullpath = '/root'
    params = { :class => 'testing', :active => :inclusive }
    out = active_link_to 'label', '/root', params
    assert_html out, 'a.testing.active[href="/root"]', 'label'
    assert_equal ({:class => 'testing', :active => :inclusive }), params
  end

  def test_no_empty_class_attribute
    request.fullpath = '/root'
    link = active_link_to('label', '/root', :wrap_tag => :li)
    assert_html link, 'li.active a.active[href="/root"]', 'label'

    link = active_link_to('label', '/other', :wrap_tag => :li)
    assert_html link, 'li a[href="/other"]', 'label'
  end

  def test_active_link_to_with_url
    request.fullpath = '/root'
    link = active_link_to('label', 'http://example.com/root')
    assert_html link, 'a.active[href="http://example.com/root"]', 'label'
  end
end

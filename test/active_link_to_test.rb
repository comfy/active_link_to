require_relative 'test_helper'

class ActiveLinkToTest < MiniTest::Test

  def test_is_active_link_booleans_test
    assert is_active_link?('/', true)
    refute is_active_link?('/', false)
  end

  def test_is_active_link_symbol_inclusive
    set_fullpath('/root')
    assert is_active_link?('/root', :inclusive)

    set_fullpath('/root?param=test')
    assert is_active_link?('/root', :inclusive)

    set_fullpath('/root/child/sub-child')
    assert is_active_link?('/root', :inclusive)

    set_fullpath('/other')
    refute is_active_link?('/root', :inclusive)
  end

  def test_is_active_link_symbol_inclusive_implied
    set_fullpath('/root/child/sub-child')
    assert is_active_link?('/root')
  end

  def test_is_active_link_symbol_inclusive_similar_path
    set_fullpath('/root/abc')
    refute is_active_link?('/root/a', :inclusive)
  end

  def test_is_active_link_symbol_inclusive_with_last_slash
    set_fullpath('/root/abc')
    assert is_active_link?('/root/')
  end

  def test_is_active_link_symbol_inclusive_with_last_slash_and_similar_path
    set_fullpath('/root_path')
    refute is_active_link?('/root/')
  end

  def test_is_active_link_symbol_inclusive_with_link_params
    set_fullpath('/root?param=test')
    assert is_active_link?('/root?attr=example')
  end

  def test_is_active_link_symbol_exclusive
    set_fullpath('/root')
    assert is_active_link?('/root', :exclusive)

    set_fullpath('/root?param=test')
    assert is_active_link?('/root', :exclusive)

    set_fullpath('/root/child')
    refute is_active_link?('/root', :exclusive)
  end

  def test_is_active_link_symbol_exclusive_with_link_params
    set_fullpath('/root?param=test')
    assert is_active_link?('/root?attr=example', :exclusive)
  end

  def test_is_active_link_symbol_exact
    set_fullpath('/root?param=test')
    assert is_active_link?('/root?param=test', :exact)

    set_fullpath('/root?param=test')
    refute is_active_link?('/root?param=exact', :exact)

    set_fullpath('/root')
    refute is_active_link?('/root?param=test', :exact)

    set_fullpath('/root?param=test')
    refute is_active_link?('/root', :exact)
  end

  def test_is_active_link_regex
    set_fullpath('/root')
    assert is_active_link?('/', /^\/root/)

    set_fullpath('/root/child')
    assert is_active_link?('/', /^\/r/)

    set_fullpath('/other')
    refute is_active_link?('/', /^\/r/)
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

    refute is_active_link?('/', ['controller_a', 'action'])
    refute is_active_link?('/', ['controller', 'action_a'])
  end

  def test_is_active_link_hash
    params[:a] = 1

    assert is_active_link?('/', {a: 1})
    assert is_active_link?('/', {a: 1, b: nil})

    refute is_active_link?('/', {a: 1, b: 2})
    refute is_active_link?('/', {a: 2})

    params[:b] = 2

    assert is_active_link?('/', {a: 1, b: 2})
    assert is_active_link?('/', {a: 1, b: 2, c: nil})

    assert is_active_link?('/', {a: 1})
    assert is_active_link?('/', {b: 2})
  end

  def test_is_active_link_with_memoization
    set_fullpath('/')
    assert is_active_link?('/', :exclusive)

    set_fullpath('/other', false)
    assert is_active_link?('/', :exclusive)
  end

  def test_active_link_to_class
    set_fullpath('/root')
    assert_equal 'active', active_link_to_class('/root')
    assert_equal 'on', active_link_to_class('/root', class_active: 'on')

    assert_equal '', active_link_to_class('/other')
    assert_equal 'off', active_link_to_class('/other', class_inactive: 'off')
  end

  def test_active_link_to
    set_fullpath('/root')
    link = active_link_to('label', '/root')
    assert_html link, 'a.active[href="/root"]', 'label'

    link = active_link_to('label', '/other')
    assert_html link, 'a[href="/other"]', 'label'
  end

  def test_active_link_to_with_existing_class
    set_fullpath('/root')
    link = active_link_to('label', '/root', class: 'current')
    assert_html link, 'a.current.active[href="/root"]', 'label'

    link = active_link_to('label', '/other', class: 'current')
    assert_html link, 'a.current[href="/other"]', 'label'
  end

  def test_active_link_to_with_custom_classes
    set_fullpath('/root')
    link = active_link_to('label', '/root', class_active: 'on')
    assert_html link, 'a.on[href="/root"]', 'label'

    link = active_link_to('label', '/other', class_inactive: 'off')
    assert_html link, 'a.off[href="/other"]', 'label'
  end

  def test_active_link_to_with_wrap_tag
    set_fullpath('/root')
    link = active_link_to('label', '/root', wrap_tag: :li)
    assert_html link, 'li.active a.active[href="/root"]', 'label'

    link = active_link_to('label', '/root', wrap_tag: :li, active_disable: true)
    assert_html link, 'li.active span.active', 'label'

    link = active_link_to('label', '/root', wrap_tag: :li, class: 'testing')
    assert_html link, 'li.testing.active a.testing.active[href="/root"]', 'label'
  end

  def test_active_link_to_with_active_disable
    set_fullpath('/root')
    link = active_link_to('label', '/root', active_disable: true)
    assert_html link, 'span.active', 'label'
  end

  def test_should_not_modify_passed_params
    set_fullpath('/root')
    params = {class: 'testing', active: :inclusive}
    out = active_link_to 'label', '/root', params
    assert_html out, 'a.testing.active[href="/root"]', 'label'
    assert_equal ({class: 'testing', active: :inclusive }), params
  end

  def test_active_link_to_wrap_tag_class
    set_fullpath('/root')
    link = active_link_to('label', '/root', wrap_tag: :li)
    assert_html link, 'li.active a.active[href="/root"]', 'label'

    link = active_link_to('label', '/other', wrap_tag: :li)
    assert_html link, 'li a[href="/other"]', 'label'
  end

  def test_active_link_to_with_aria
    set_fullpath('/root')
    link = active_link_to('label', '/root')
    assert_html link, 'a.active[href="/root"][aria-current="page"]', 'label'
  end

  def test_active_link_to_with_utf8
    set_fullpath('/äöü')
    link = active_link_to('label', '/äöü')
    assert_html link, 'a.active[href="/äöü"]', 'label'
  end
end

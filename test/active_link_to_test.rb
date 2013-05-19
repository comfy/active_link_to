require 'test_helper'

class ActiveLinkToTest < Test::Unit::TestCase

  def test_is_active_link_booleans
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
    assert_equal '<a class="active" href="/root">label</a>', link

    link = active_link_to('label', '/other')
    assert_equal '<a href="/other">label</a>', link
  end

  def test_active_link_to_with_existing_class
    request.fullpath = '/root'
    link = active_link_to('label', '/root', :class => 'current')
    assert_equal '<a class="current active" href="/root">label</a>', link

    link = active_link_to('label', '/other', :class => 'current')
    assert_equal '<a class="current" href="/other">label</a>', link
  end

  def test_active_link_to_with_custom_classes
    request.fullpath = '/root'
    link = active_link_to('label', '/root', :class_active => 'on')
    assert_equal '<a class="on" href="/root">label</a>', link

    link = active_link_to('label', '/other', :class_inactive => 'off')
    assert_equal '<a class="off" href="/other">label</a>', link
  end

  def test_active_link_to_with_wrap_tag
    request.fullpath = '/root'
    link = active_link_to('label', '/root', :wrap_tag => :li)
    assert_equal '<li class="active"><a class="active" href="/root">label</a></li>', link

    link = active_link_to('label', '/root', :wrap_tag => :li, :active_disable => true)
    assert_equal '<li class="active"><span class="active">label</span></li>', link

    link = active_link_to('label', '/root', :wrap_tag => :li, :class => 'testing')
    assert_equal '<li class="testing active"><a class="testing active" href="/root">label</a></li>', link
  end

  def test_active_link_to_with_active_disable
    request.fullpath = '/root'
    link = active_link_to('label', '/root', :active_disable => true)
    assert_equal '<span class="active">label</span>', link
  end

  def test_should_not_modify_passed_params
    request.fullpath = '/root'
    params = { :class => 'testing', :active => :inclusive }
    out = active_link_to 'label', '/root', params
    assert_equal '<a class="testing active" href="/root">label</a>', out
    assert_equal ({:class => 'testing', :active => :inclusive }), params
  end

end

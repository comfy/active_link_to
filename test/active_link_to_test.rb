require 'test_helper'

class ActiveLinkToTest < Test::Unit::TestCase
  
  def test_matching_self
    request.fullpath = '/test'
    out = active_link_to 'name', '/test'
    assert_equal '<a href="/test" class="active">name</a>', out
    out = active_link_to 'name', '/test', :active => { :when => :self }
    assert_equal '<a href="/test" class="active">name</a>', out
    out = active_link_to 'name', '/not-test'
    assert_equal '<a href="/not-test">name</a>', out
  end
  
  def test_matching_self_with_extra_parameters
    request.fullpath = '/test?status=what'
    out = active_link_to 'name', '/test'
    assert_equal '<a href="/test" class="active">name</a>', out
  end
  
  def test_matching_self_only
    request.fullpath = '/test/fail'
    out = active_link_to 'name', '/test/fail', :active => { :when => :self_only }
    assert_equal '<a href="/test/fail" class="active">name</a>', out
    out = active_link_to 'name', '/test', :active => { :when => :self_only }
    assert_equal '<a href="/test">name</a>', out
  end
  
  def test_matching_self_only_with_extra_parameters
    request.fullpath = '/test/fail?why=because'
    out = active_link_to 'name', '/test/fail', :active => { :when => :self_only }
    assert_equal '<a href="/test/fail" class="active">name</a>', out
  end
  
  def test_matching_custom_regex
    request.fullpath = '/test/something_else'
    out = active_link_to 'name', '/test', :active => { :when => /^\/te/}
    assert_equal '<a href="/test" class="active">name</a>', out
    out = active_link_to 'name', '/test', :active => { :when => /^\/no/}
    assert_equal '<a href="/test">name</a>', out
  end
  
  def test_matching_controller_action_touples
    request.fullpath = '/test/23'
    params[:controller], params[:action] = 'tests', 'show'
    out = active_link_to 'name', '/test/23', :active => { :when => [['tests'], ['show', 'edit']]}
    assert_equal '<a href="/test/23" class="active">name</a>', out
    out = active_link_to 'name', '/test/23', :active => { :when => [['tests'], []]}
    assert_equal '<a href="/test/23" class="active">name</a>', out
    out = active_link_to 'name', '/test/23', :active => { :when => [[], ['show']]}
    assert_equal '<a href="/test/23" class="active">name</a>', out
    out = active_link_to 'name', '/test/23', :active => { :when => [['tests'], ['update']]}
    assert_equal '<a href="/test/23">name</a>', out
  end
  
  def test_matching_booleans
    request.fullpath = 'doesnotmatter'
    out = active_link_to 'name', '/test', :active => { :when => true }
    assert_equal '<a href="/test" class="active">name</a>', out
    out = active_link_to 'name', '/test', :active => { :when => false }
    assert_equal '<a href="/test">name</a>', out
  end
  
  def test_setting_active_class
    request.fullpath = '/test'
    out = active_link_to 'name', '/test', :active => { :active_class => 'new_active'}
    assert_equal '<a href="/test" class="new_active">name</a>', out
  end
  
  def test_setting_inactive_class
    request.fullpath = '/test'
    out = active_link_to 'name', '/not-test', :active => { :inactive_class => 'new_inactive'}
    assert_equal '<a href="/not-test" class="new_inactive">name</a>', out
  end
  
  def test_transforming_to_span
    request.fullpath = '/test'
    out = active_link_to 'name', '/test', :active => { :disable_link => true }
    assert_equal '<span class="active">name</span>', out
  end
  
  def test_should_not_modify_passed_params
    request.fullpath = '/test'
    params = {:class => 'testing'}
    out = active_link_to 'name', '/test', params
    assert_equal '<a href="/test" class="testing active">name</a>', out
    assert_equal ({:class => 'testing'}), params
  end
  
end

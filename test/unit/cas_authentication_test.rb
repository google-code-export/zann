require File.dirname(__FILE__) + '/../test_helper'
require 'cas_authentication'

class VideoTest < ActiveSupport::TestCase
  attr_accessor :current_user
  attr_accessor :session
  include CASAuthentication
  
  def test_cas_authentication
    CONFIG['cas_enabled'] = true
    self.session = {:cas_user => 'cas.exmple.com\joe'}
    cas_login
    CONFIG['cas_enabled'] = false
    assert_not_nil current_user
    assert_not_nil current_user.id
    assert_equal 'joe', current_user.login
    assert_equal 'joe@example.com', current_user.email
  end
  
  def test_cas_authentication_triple_slashes
    CONFIG['cas_enabled'] = true
    self.session = {:cas_user => 'cas.exmple.com\joe\corp\joe'}
    cas_login
    CONFIG['cas_enabled'] = false
    assert_not_nil current_user
    assert_not_nil current_user.id
    assert_equal 'joe', current_user.login
    assert_equal 'joe@example.com', current_user.email
  end
  
  def test_cas_authentication_double_continuous_slashes
    CONFIG['cas_enabled'] = true
    self.session = {:cas_user => 'cas.exmple.com\\joe'}
    cas_login
    CONFIG['cas_enabled'] = false
    assert_not_nil current_user
    assert_not_nil current_user.id
    assert_equal 'joe', current_user.login
    assert_equal 'joe@example.com', current_user.email
  end
  
end

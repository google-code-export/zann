require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :users

  def test_should_create_user
    assert_difference User, :count do
      user = create_user
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
  end

  def test_should_require_login
    assert_no_difference User, :count do
      u = create_user(:login => nil)
      assert u.errors.on(:login)
    end
  end

  def test_should_require_password
    assert_no_difference User, :count do
      u = create_user(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference User, :count do
      u = create_user(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  def test_should_require_email
    assert_no_difference User, :count do
      u = create_user(:email => nil)
      assert u.errors.on(:email)
    end
  end
  
#  def test_should_require_internal_email
#      u = create_user(:email => 'nounderscore@example.com')
#      assert u.errors.on(:email)
#      u = create_user(:email => 'non_emc@nonexample.com')
#      assert u.errors.on(:email)
#      u = create_user(:email => 'non_plus+plus@example.com')
#      assert u.errors.on(:email)
#  end
  
  def test_should_reset_password
    users(:samuel).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal users(:samuel), User.authenticate('samuel', 'new password')
  end

  def test_should_not_rehash_password
    users(:samuel).update_attributes(:login => 'samuel2')
    assert_equal users(:samuel), User.authenticate('samuel2', 'test')
  end

  def test_should_authenticate_user
    assert_equal users(:samuel), User.authenticate('samuel', 'test')
  end

  def test_should_set_remember_token
    users(:samuel).remember_me
    assert_not_nil users(:samuel).remember_token
    assert_not_nil users(:samuel).remember_token_expires_at
  end

  def test_should_unset_remember_token
    users(:samuel).remember_me
    assert_not_nil users(:samuel).remember_token
    users(:samuel).forget_me
    assert_nil users(:samuel).remember_token
  end
  
  protected
    def create_user(options = {})
      User.create({ :login => 'quire', :email => 'quire_steven@emc.com', :password => 'quire', :password_confirmation => 'quire', :first_name => 'quire', :last_name => 'steven' }.merge(options))
    end
end

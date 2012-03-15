require File.dirname(__FILE__) + '/../test_helper'

class SnackTest < ActiveSupport::TestCase
  fixtures :snacks, :zanns, :users
  
  def setup
    setup_fixture_files
  end

  def test_create_snack
    snack_amount = Snack.count
    bread = Snack.new({
	:name => 'Bread',
	:description => '面包很难吃.',
	:creator_id => 3,
	:image => upload("#{RAILS_ROOT}/test/fixtures/file_column/test/bread.jpg")
    })
    assert bread.save
    assert_equal snack_amount + 1, Snack.count
  end

  def teardown
    teardown_fixture_files
  end
end

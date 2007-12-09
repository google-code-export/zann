require File.dirname(__FILE__) + '/../test_helper'

require 'test/unit'
require 'thumbnail'
class ThumbnailTest < Test::Unit::TestCase
  include ImageProcessing
  def setup
  end

  def test_small_size_image_name
    assert_equal('/path/to/image_s.jpg', small_size_image_name('/path/to/image.jpg'))
  end

  def test_medium_size_image_name
    assert_equal('/path/to/image_m.jpg', medium_size_image_name('/path/to/image.jpg'))
  end

  def test_create_thumb
    image_dir = File.join(RAILS_ROOT, 'test', 'unit', 'data')
    create_thumb(File.join(image_dir, 'apple.jpg'))
    assert File.exist?(File.join(image_dir, 'apple_m.jpg'))
    assert File.exist?(File.join(image_dir, 'apple_s.jpg'))
    File.delete(File.join(image_dir, 'apple_m.jpg'))
    File.delete(File.join(image_dir, 'apple_s.jpg'))
  end

  def teardown
  end

end

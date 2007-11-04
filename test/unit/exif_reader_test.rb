require File.dirname(__FILE__) + '/../test_helper'

class ExifReaderTest < Test::Unit::TestCase
  
  def setup
  end

  def test_read_exif
    ExifReader.read()
  end

  def teardown
  end
end

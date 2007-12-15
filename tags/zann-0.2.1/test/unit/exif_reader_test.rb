require File.dirname(__FILE__) + '/../test_helper'

class ExifReaderTest < Test::Unit::TestCase
  
  def setup
  end

  def test_read_exif
    exif_info = ExifReader.read(File.join(RAILS_ROOT, 'test', 'unit', 'data', 'test.jpg'))
    assert_equal "'NIKON CORPORATION'", exif_info[:make]
    assert_equal "'NIKON D50'", exif_info[:model]
    assert_equal "500", exif_info[:pixel_x_dimension]
    assert_equal "332", exif_info[:pixel_y_dimension]
    assert_equal "'Adobe Photoshop 7.0'", exif_info[:software]
    assert_equal "8", exif_info[:fnumber]
    assert_equal "10/80", exif_info[:exposure_time]
    assert_equal "0", exif_info[:flash]
    assert_equal "38", exif_info[:focal_length]
    assert_equal "0", exif_info[:white_balance]
    assert_equal "2006-09-06T17:27:39.000+0800", exif_info[:date_time]
  end

  def test_fail_to_extract_exif
    exif_info = ExifReader.read(File.join(RAILS_ROOT, 'test', 'unit', 'data', 'IMG_9150.jpg'))
    assert_equal 0, exif_info.length
  end

  def teardown
  end
end

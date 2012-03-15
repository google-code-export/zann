require File.dirname(__FILE__) + '/../test_helper'

class ExifTest < ActiveSupport::TestCase
  def test_create_exif
    exif = Exif.new(
      :model => 'Nikon D50',
      :make => 'NIKON CORPRATION',
      :pixel_x_dimension => '100',
      :pixel_x_dimension => '1024',
      :software => 'Adobe Photoshop',
      :fnumber => 'fnumber 70',
      :exposure_time => 'exposure_time 10/80',
      :flash => '0',
      :focal_length => '100',
      :white_balance => '0',
      :date_time => '2007-12-11',
      :photo_id => 1
    )
    assert exif.save
    assert_equal 'Nikon D50', exif.model
  end
end

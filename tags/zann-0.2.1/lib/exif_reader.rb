include Java
require 'lib/sanselan.jar'
include_class Java::org.apache.sanselan.ImageReadException
include_class Java::org.apache.sanselan.Sanselan
include_class Java::org.apache.sanselan.common.IImageMetadata
include_class Java::org.apache.sanselan.formats.jpeg.JpegImageMetadata
include_class Java::org.apache.sanselan.formats.tiff.TagInfo
include_class Java::org.apache.sanselan.formats.tiff.TiffConstants
include_class Java::org.apache.sanselan.formats.tiff.TiffField

class ExifReader
  def self.read(file)
    exif_info = {}
    begin
      metadata = Sanselan.getMetadata(java.io.File.new(file));
      if(metadata.kind_of?(JpegImageMetadata))
        exif_info[:date_time] = get_value_description(metadata, TiffConstants::TIFF_TAG_DateTime)
        exif_info[:make] = get_value_description(metadata, TiffConstants::TIFF_TAG_Make)
        exif_info[:model] = get_value_description(metadata, TiffConstants::TIFF_TAG_Model)
        exif_info[:pixel_x_dimension] = get_value_description(metadata, TiffConstants::TIFF_TAG_PixelXDimension)
        exif_info[:pixel_y_dimension] = get_value_description(metadata, TiffConstants::TIFF_TAG_PixelYDimension)
        exif_info[:software] = get_value_description(metadata, TiffConstants::TIFF_TAG_Software)
        exif_info[:exposure_time] = get_value_description(metadata, TiffConstants::TIFF_TAG_ExposureTime)
        exif_info[:fnumber] = get_value_description(metadata, TiffConstants::TIFF_TAG_FNumber)
        exif_info[:flash] = get_value_description(metadata, TiffConstants::TIFF_TAG_Flash)
        exif_info[:focal_length] = get_value_description(metadata, TiffConstants::TIFF_TAG_FocalLength)
        exif_info[:white_balance] = get_value_description(metadata, TiffConstants::TIFF_TAG_WhiteBalance)
      end
    rescue
      exif_info = {}
    end
    return exif_info
  end
  private
  def self.get_value_description(metadata, tag)
    tag_value = metadata.findEXIFValue(tag)
    value_description = ""
    value_description = tag_value.getValueDescription() if !tag_value.nil?
    return value_description
  end
end
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
    metadata = Sanselan.getMetadata(java.io.File.new(file));
    if(metadata.kind_of?(JpegImageMetadata))
      exif_info[:date_time] = metadata.findEXIFValue(TiffConstants::TIFF_TAG_DateTime)
      exif_info[:make] = metadata.findEXIFValue(TiffConstants::TIFF_TAG_Make).getValueDescription()
      exif_info[:model] = metadata.findEXIFValue(TiffConstants::TIFF_TAG_Model).getValueDescription()
      exif_info[:pixel_x_dimension] = metadata.findEXIFValue(TiffConstants::TIFF_TAG_PixelXDimension).getValueDescription()
      exif_info[:pixel_y_dimension] = metadata.findEXIFValue(TiffConstants::TIFF_TAG_PixelYDimension).getValueDescription()
      exif_info[:software] = metadata.findEXIFValue(TiffConstants::TIFF_TAG_Software).getValueDescription()
      exif_info[:exposure_time] = metadata.findEXIFValue(TiffConstants::TIFF_TAG_ExposureTime).getValueDescription()
      exif_info[:fnumber] = metadata.findEXIFValue(TiffConstants::TIFF_TAG_FNumber).getValueDescription()
      exif_info[:flash] = metadata.findEXIFValue(TiffConstants::TIFF_TAG_Flash).getValueDescription()
      exif_info[:focal_length] = metadata.findEXIFValue(TiffConstants::TIFF_TAG_FocalLength).getValueDescription()
      exif_info[:white_balance] = metadata.findEXIFValue(TiffConstants::TIFF_TAG_WhiteBalance).getValueDescription()
    end
    return exif_info
  end
end
include Java
require 'lib/sanselan.jar'
include_class Java::org.apache.sanselan.ImageReadException
include_class Java::org.apache.sanselan.Sanselan
include_class Java::org.apache.sanselan.common.IImageMetadata

class ExifReader

  def self.read
    puts "reading exif info"
  end
end
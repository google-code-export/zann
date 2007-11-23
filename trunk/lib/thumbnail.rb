require 'ftools'
include Java
require 'lib/jthumb-0.1.jar'
include_class Java::com.googlecode.zann.ImageScalor

module ImageProcessing
  MEDIUM_IMAGE_SIZE = 640
  SMALL_IMAGE_SIZE = 160

  #append an 's' into the basename of an image file
  # /path/to/image_name.jpg => /path/to/image_name_s.jpg
  def small_size_image_name(image)
    "#{File.dirname(image)}#{File::SEPARATOR}#{File.basename(image, File.extname(image))}_s#{File.extname(image)}"
  end

  #append an 'm' into the basename of an image file
  # /path/to/image_name.jpg => /path/to/image_name_m.jpg
  def medium_size_image_name(image)
    "#{File.dirname(image)}#{File::SEPARATOR}#{File.basename(image, File.extname(image))}_m#{File.extname(image)}"
  end

  def medium_size_file_url(object, method)
    if(File.exist?(medium_size_image_name(object.send(method))))
      return medium_size_image_name(url_for_file_column(object, method))
    else
      return url_for_file_column(object, method)
    end
  end

  def small_size_file_url(object, method)
    if(File.exist?(small_size_image_name(object.send(method))))
      return small_size_image_name(url_for_file_column(object, method))
    else
      return url_for_file_column(object, method)
    end
  end
  # full image file path
  def create_thumb(image)
    image_scalor = ImageScalor.new(image)
    image_width = image_scalor.getImageWidth
    if(image_width > MEDIUM_IMAGE_SIZE)
      image_scalor.scale(medium_size_image_name(image), MEDIUM_IMAGE_SIZE)
      image_scalor.scale(small_size_image_name(image), SMALL_IMAGE_SIZE)
    elsif(SMALL_IMAGE_SIZE < image_width and image_width <= MEDIUM_IMAGE_SIZE) 
      image_scalor.scale(small_size_image_name(image), SMALL_IMAGE_SIZE)
    end
  end
end
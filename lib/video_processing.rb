module VideoProcessing
  FLASH_VIDEO_RESOLUTION = '640x480'
  def convert_video(file_path)
    converted_file_path = flash_video_file_name(file_path)
    if(File.exist?(converted_file_path))
      File.delete(converted_file_path)
    end
    system("ffmpeg -i #{file_path} -acodec mp3 -ar 22050 -ab 32 -f flv -s #{FLASH_VIDEO_RESOLUTION} #{converted_file_path}")
    video_preview_image = flash_video_preview_image(file_path)
    if(File.exist?(video_preview_image))
      File.delete(video_preview_image)
    end
    system("ffmpeg -i #{converted_file_path} -vcodec png -vframes 1 -ss 00:00:03 -an -f rawvideo #{video_preview_image}")
  end

  def flash_video_url(object, method)
    flash_video_file_name(url_for_file_column(object, method))
  end

  def flash_video_preview_image_url(object, method)
    flash_video_preview_image(url_for_file_column(object, method))
  end

  def flash_video_preview_image(file_path)
    "#{File.dirname(file_path)}#{File::SEPARATOR}#{File.basename(file_path, File.extname(file_path))}.png"
  end

  def flash_video_file_name(file_path)
    "#{File.dirname(file_path)}#{File::SEPARATOR}#{File.basename(file_path, File.extname(file_path))}.flv"
  end
end
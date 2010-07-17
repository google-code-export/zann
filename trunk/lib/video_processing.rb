module VideoProcessing
  FLASH_VIDEO_RESOLUTION = '640x360'
  # setup the path for ffmpeg
  def convert_video(file_path)
    converted_file_path = flash_video_file_name(file_path)
    if(File.exist?(converted_file_path))
      File.delete(converted_file_path)
    end
    raise "ffmpeg command is unavailable at #{FFMPEG_PATH}, please define it in FFMPEG_PATH in environment.rb." unless File.exist?(FFMPEG_PATH)
    system("#{FFMPEG_PATH} -i #{file_path} -acodec #{MP3_CODEC} -ar 22050 -ab 32 -b 400 -f flv -s #{FLASH_VIDEO_RESOLUTION} #{converted_file_path}")
    video_preview_image = flash_video_preview_image(file_path)
    if(File.exist?(video_preview_image))
      File.delete(video_preview_image)
    end
    # create a preview image for this video
    system("#{FFMPEG_PATH} -i #{converted_file_path} -vframes 1 -ss 00:00:03 -an -f mjpeg #{video_preview_image}")
  end

  def flash_video_url(object, method)
    flash_video_file_name(url_for_file_column(object, method))
  end

  def flash_video_preview_image_url(object, method)
    flash_video_preview_image(url_for_file_column(object, method))
  end

  def flash_video_preview_image(file_path)
    "#{File.dirname(file_path)}#{File::SEPARATOR}#{File.basename(file_path, File.extname(file_path))}.jpg"
  end

  def flash_video_file_name(file_path)
    "#{File.dirname(file_path)}#{File::SEPARATOR}#{File.basename(file_path, File.extname(file_path))}.flv"
  end
end
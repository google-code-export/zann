require 'exif_reader'
module FileColumn
  class BaseUploadedFile
    def extract_exif_info
      begin
        exif_info = ExifReader.read(absolute_path)
        return exif_info
      rescue
        return {}
      end
    end
  end

  module ExifExtension
    def self.file_column(klass, attr, options) # :nodoc:
      state_method = "#{attr}_state".to_sym
      after_assign_method = "#{attr}_exif_after_assign".to_sym
      
      klass.send(:define_method, after_assign_method) do
        begin
          exif_info = self.send(state_method).extract_exif_info
          exif = Exif.new(exif_info)
          self.exif = exif
        rescue
          logger.error('Error occured during extracting EXIF info.')
        end
      end
      
      options[:after_upload] ||= []
      options[:after_upload] << after_assign_method
    end
  end
end
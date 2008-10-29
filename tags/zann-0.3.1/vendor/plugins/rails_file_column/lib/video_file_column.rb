require 'video_processing'
module FileColumn
  class BaseUploadedFile
    include VideoProcessing
    def convert_uploaded_video
      convert_video(absolute_path)
    end
  end

  module VideoExtension
    def self.file_column(klass, attr, options) # :nodoc:
      state_method = "#{attr}_state".to_sym
      after_assign_method = "#{attr}_video_after_assign".to_sym
      
      klass.send(:define_method, after_assign_method) do
        self.send(state_method).convert_uploaded_video
      end
      
      options[:after_upload] ||= []
      options[:after_upload] << after_assign_method
    end
  end
end
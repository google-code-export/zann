require 'thumbnail'
module FileColumn
  class BaseUploadedFile
    include ImageProcessing
    def create_thumb_with_jthumb
      create_thumb(absolute_path)
    end
  end

  module JthumbExtension
    def self.file_column(klass, attr, options) # :nodoc:
      state_method = "#{attr}_state".to_sym
      after_assign_method = "#{attr}_jthumb_after_assign".to_sym
      
      klass.send(:define_method, after_assign_method) do
        self.send(state_method).create_thumb_with_jthumb
      end
      
      options[:after_upload] ||= []
      options[:after_upload] << after_assign_method
    end
  end
end
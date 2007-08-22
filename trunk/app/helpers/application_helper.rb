# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def error_messages_for(*params)
    options = params.last.is_a?(Hash) ? params.pop.symbolize_keys : {}
    objects = params.collect {|object_name| instance_variable_get("@#{object_name}") }.compact
    count   = objects.inject(0) {|sum, object| sum + object.errors.count }
    unless count.zero?
      html = {}
      [:id, :class].each do |key|
        if options.include?(key)
          value = options[key]
          html[key] = value unless value.blank?
        else
          html[key] = 'errorExplanation'
        end
      end
      header_message = "#{pluralize(count, 'error')} prohibited this #{(options[:object_name] || params.first).to_s.gsub('_', ' ')} from being saved"
      error_messages = objects.map {|object| object.errors.full_messages.map {|msg| content_tag(:li, msg) } }
      content_tag(:div,
                  content_tag(:p, 'There were problems with the following fields:') <<
                  content_tag(:ul, error_messages),
                  html
                  )
    else
      ''
    end
  end
end

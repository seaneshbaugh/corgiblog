Paperclip.interpolates :style_prefix do |attachment, style|
  style == :original ? '' : "#{style.to_s}_"
end

Paperclip.interpolates :class_singular do |attachment, style|
  attachment.instance.class.to_s.underscore
end

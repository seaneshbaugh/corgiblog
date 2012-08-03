require 'paperclip'
require 'pp'

module Paperclip
  module Task
    def self.obtain_class
      class_name = ENV['CLASS'] || ENV['class']
      raise "Must specify CLASS" unless class_name
      class_name
    end

    def self.obtain_attachments(klass)
      klass = Paperclip.class_for(klass.to_s)
      name = ENV['ATTACHMENT'] || ENV['attachment']
      raise "Class #{klass.name} has no attachments specified" unless klass.respond_to?(:attachment_definitions)
      if !name.blank? && klass.attachment_definitions.keys.map(&:to_s).include?(name.to_s)
        [ name ]
      else
        klass.attachment_definitions.keys
      end
    end
  end
end

namespace :paperclip do
  namespace :refresh do
    desc 'Regenerates width/height metadata for a given CLASS (and optional ATTACHMENT).'
    task :dimensions => :environment do
      klass = Paperclip::Task.obtain_class
      names = Paperclip::Task.obtain_attachments(klass)
      styles = ENV['STYLE'] || ENV['style']

      if styles
        styles = styles.split(',').map { |style| style.strip.to_sym }
      end

      names.each do |name|
        Paperclip.each_instance_with_attachment(klass, name) do |instance|
          attachment = instance.send(name)

          if styles.nil? || styles.empty?
            styles = instance.send(name).styles.map { |style| style[0] }

            styles << :original
          end

          styles.uniq!

          styles.each do |style|
            file = attachment.to_file(style)

            updated = false

            if file
              geometry = Paperclip::Geometry.from_file(file)

              instance.send("#{name}_#{style}_width=", geometry.width)
              instance.send("#{name}_#{style}_height=", geometry.height)

              updated = true
            else
              puts "Style \"#{style}\" does not exist!"
            end

            if updated
              instance.save
            end
          end
        end
      end
    end
  end
end

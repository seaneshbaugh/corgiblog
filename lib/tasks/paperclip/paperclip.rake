require 'paperclip'

# This is so we don't have to copy the default paperclip rake tasks.
gem_spec = Gem::Specification.find_by_name('paperclip')

load "#{gem_spec.gem_dir}/lib/tasks/paperclip.rake"

namespace :paperclip do
  namespace :refresh do
    desc 'Regenerates width/height metadata for a given CLASS (and optional ATTACHMENT and STYLES splitted by comma).'
    task dimensions: :environment do
      klass = Paperclip::Task.obtain_class

      names = Paperclip::Task.obtain_attachments(klass)

      styles = (ENV['STYLES'] || ENV['styles'] || '').split(',').map(&:to_sym)

      names.each do |name|
        Paperclip.each_instance_with_attachment(klass, name) do |instance|
          attachment = instance.send(name)

          if styles.nil? || styles.empty?
            styles = attachment.styles.map { |style, _| style }

            styles << :original
          end

          styles.uniq!

          updated = false

          styles.each do |style|
            if style != :original
              io_adapter = Paperclip.io_adapters.for(attachment.styles[style])
            else
              io_adapter = Paperclip.io_adapters.for(attachment)
            end

            file = io_adapter.binmode

            if file
              geometry = Paperclip::Geometry.from_file(file)

              instance.send("#{name}_#{style}_width=", geometry.width)

              instance.send("#{name}_#{style}_height=", geometry.height)

              updated = true
            else
              puts "Style \"#{style}\" does not exist!"
            end
          end

          instance.save(validate: false) if updated
        end
      end
    end

    desc 'Regenerates MD5 fingerprint for a given CLASS (and optional ATTACHMENT).'
    task fingerprint: :environment do
      klass = Paperclip::Task.obtain_class

      names = Paperclip::Task.obtain_attachments(klass)

      names.each do |name|
        Paperclip.each_instance_with_attachment(klass, name) do |instance|
          attachment = instance.send(name)

          io_adapter = Paperclip.io_adapters.for(attachment)

          file = io_adapter.binmode

          if file
            instance.send("#{name}_fingerprint=", Digest::MD5.hexdigest(file.read))

            instance.save(validate: false)
          end
        end
      end
    end
  end
end

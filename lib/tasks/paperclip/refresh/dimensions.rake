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
  end
end

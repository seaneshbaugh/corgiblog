namespace :paperclip do
  namespace :refresh do
    desc 'Regenerates MD5 fingerprint for a given CLASS (and optional ATTACHMENT).'
    task fingerprint: :environment do
      klass = Paperclip::Task.obtain_class

      names = Paperclip::Task.obtain_attachments(klass)

      names.each do |name|
        Paperclip.each_instance_with_attachment(klass, name) do |instance|
          attachment = instance.send(name)

          io_adapter = Paperclip.io_adapters.for(attachment)

          file = io_adapter.binmode

          next unless file

          instance.send("#{name}_fingerprint=", Digest::MD5.hexdigest(file.read))

          instance.save(validate: false)
        end
      end
    end
  end
end

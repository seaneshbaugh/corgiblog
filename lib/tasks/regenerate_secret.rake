desc "Regenerate the secret token"
task :regenerate_secret => :environment do
  include ActiveSupport
  File.open(File.join(Rails.root, 'config', 'initializers', 'secret_token.rb'), 'w') do |f|
    f.puts "#{Rails.application.class.parent_name}::Application.config.secret_token = '#{SecureRandom.hex(64)}'"
  end
end

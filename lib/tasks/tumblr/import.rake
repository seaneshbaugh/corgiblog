namespace :tumblr do
  desc 'Import posts from tumblr.'
  task import: :environment do
    Tumblr::Import.call
  end
end

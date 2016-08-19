Rails.application.config.autoload_paths += Dir[Rails.root.join('app', 'builders', '{**}')]

Rails.application.config.autoload_paths += Dir[Rails.root.join('app', 'models', '{**}')]

Rails.application.config.autoload_paths += Dir[Rails.root.join('app', 'presenters', '{**}')]

Rails.application.config.autoload_paths += Dir[Rails.root.join('app', 'services', '{**}')]

Rails.application.config.autoload_paths += Dir[Rails.root.join('app', 'validators', '{**}')]

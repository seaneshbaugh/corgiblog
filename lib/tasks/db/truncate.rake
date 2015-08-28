namespace :db do
  desc 'Truncate the database tables'
  task truncate: :environment do
    ActiveRecord::Base.connection.tables.select { |table_name| table_name != 'schema_migrations' }.each do |table_name|
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table_name}")
    end
  end
end

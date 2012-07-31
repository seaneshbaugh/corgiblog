%x[rake db:data:load]

load 'user.rb'

users = User.all

users.each do |user|
  user.password = "changeme"
  user.save!
end

sysadmin_user = User.create({ :email => 'sysadmin@conneythecorgi.com', :password =>'changeme', :role => 'sysadmin', :first_name => 'Sysadmin', :last_name => 'User' })

sysadmin_user.save!

admin_user = User.create({ :email => 'admin@conneythecorgi.com', :password =>'changeme', :role => 'admin', :first_name => 'Admin', :last_name => 'User' })

admin_user.save!

contributor_user = User.create({ :email => 'contributor@conneythecorgi.com', :password =>'changeme', :role => 'contributor', :first_name => 'Contributor', :last_name => 'User' })

contributor_user.save!

read_only_user = User.create({ :email => 'read_only@conneythecorgi.com', :password =>'changeme', :role => 'read_only', :first_name => 'Read Only', :last_name => 'User' })

read_only_user.save!

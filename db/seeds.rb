%x[rake db:data:load]

load 'user.rb'

users = User.all

users.each do |user|
  user.password = "changeme"
  user.save!
end

admin_user = User.create({ :email => 'admin@conneythecorgi.com', :password =>'changeme', :role => 'sysadmin', :first_name => 'Admin', :last_name => 'User' })

admin_user.save!
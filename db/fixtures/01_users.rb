id = 1

User.seed do |s|
  s.id = id
  s.email = 'sean@conneythecorgi.com'
  s.password = 'changeme'
  s.role = 'sysadmin'
  s.first_name = 'Sean'
  s.last_name = 'Eshbaugh'

  id += 1
end

User.seed do |s|
  s.id = id
  s.email = 'casie@conneythecorgi.com'
  s.password = 'changeme'
  s.role = 'admin'
  s.first_name = 'Casie'
  s.last_name = 'Clark'

  id += 1
end

User.seed do |s|
  s.id = id
  s.email = 'conney@conneythecorgi.com'
  s.password = 'changeme'
  s.role = 'read_only'
  s.first_name = 'Conney'
  s.last_name = 'Clark-Eshbaugh'

  id += 1
end

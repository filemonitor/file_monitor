puts 'SETTING UP DEFAULT USER LOGIN'
user = User.create!(
  email:    'user@example.com',
  password: 'please',
  password_confirmation: 'please'
)

puts 'New user created: ' << user.email
user2 = User.create!(
  email:                 'user2@example.com',
  password:              'please2',
  password_confirmation: 'please2'
)
puts 'New user created: ' << user2.email
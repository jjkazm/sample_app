# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(name: "Kuba", email: "jjkazm@gmail.com", password: "haslo1",
            password_confirmation: "haslo1", admin: true,
            activated: true, activated_at: Time.zone.now)

99.times do |n|
  name = Faker::Name.name
  email = "exmple-#{n+1}@wp.pl"
  password = "pass123"
  password_confirmation = "pass123"
  User.create!(name: name, email: email, password: password,
              password_confirmation: password_confirmation,
              activated: true, activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6)
users.each do |user|
  50.times do |n|
    content = Faker::Lorem.sentence(5)
    user.microposts.create!(content: content)
  end
end


# Seeding following and followers
user = User.first
users = User.all

followers = users[3..40]
followers.each {|follower| follower.follow(user)}

followees = users[2..50]
followees.each { |followee| user.follow(followee)}

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create! name: "Regular user", email: "regular-user@example.com", password: "secret", password_confirmation: "secret"
50.times { |i| 
  Meal.create!(user: user, name: "Meal #{i + 1}", calories: 250, eaten_at: Time.now - i.days)
}

User.create! name: "User manager", email: "user-manager@example.com", password: "secret", password_confirmation: "secret", role: "user_manager"
User.create! name: "Admin", email: "admin@example.com", password: "secret", password_confirmation: "secret", role: "admin"

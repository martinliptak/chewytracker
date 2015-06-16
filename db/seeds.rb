# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create! name: "Regular user", email: "regular-user@example.com", password: "secret", password_confirmation: "secret"
User.create! name: "User manager", email: "user-manager@example.com", password: "secret", password_confirmation: "secret", role: "user_manager"
User.create! name: "Admin", email: "admin@example.com", password: "secret", password_confirmation: "secret", role: "admin"

User.all.each { |user|
  10.times { |i|
    day = Time.now - (i + 1).days
    day = DateTime.new(day.year, day.month, day.day, 0, 0, 0)
    day_of_week = day.strftime("%A")

    {
      "Breakfast" => 9, 
      "Lunch" => 12, 
      "Dinner" => 18
    }.each { |meal, h|
      Meal.create!(user: user, name: "#{meal} on #{day_of_week}", calories: 250, eaten_at: day + h.hours)
    }
  }
}

FactoryGirl.define do
  factory :meal do
    name "Meal 1"
    calories 100
    eaten_at Time.now
    
    user
  end
end
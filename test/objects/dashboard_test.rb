require "test_helper"

describe Dashboard, :model do
  it "computes total calories for today" do
    user = FactoryGirl.build(:user)
    user.meals.build(name: "Meal 1", calories: 10, eaten_at: Time.now)
    user.meals.build(name: "Meal 2", calories: 20, eaten_at: Time.now)
    user.meals.build(name: "Meal 3", calories: 30, eaten_at: Time.now - 2.days)
    user.save

    dashboard = Dashboard.new(user, {})

    dashboard.total_calories.must_equal 30
  end
end

require "test_helper"

describe Meal do
  let(:meal) { Meal.new(name: "Double Cheeseburger", calories: 1_000_000, eaten_at: Time.now) }

  it "must be valid" do
    value(meal).must_be :valid?
  end
end

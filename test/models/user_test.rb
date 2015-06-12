require "test_helper"

describe User do
  let(:user_params) { 
    { 
      name: "I Am Grook", 
      email: "iamgrook@example.com", 
      password: "password", 
      password_confirmation: "password" 
    } 
  }
  let(:user) { 
    User.new user_params 
  }

  it "is valid with valid params" do
    user.must_be :valid?
  end

  it "is invalid without required params" do
    user_params.clear

    user.wont_be :valid?
    user.errors[:name].must_be :present? 
    user.errors[:email].must_be :present? 
    user.errors[:password].must_be :present? 
    user.errors[:password_confirmation].must_be :present? 
  end

  it "has default settings after save" do
    user.save
    user.settings.must_equal Hash.new
    user.role.must_equal "regular"
    user.expected_calories.must_equal 2000
  end

  it "computes total calories for today" do
    user.meals.build(name: "Meal 1", calories: 10, eaten_at: Time.now)
    user.meals.build(name: "Meal 2", calories: 20, eaten_at: Time.now)
    user.meals.build(name: "Meal 3", calories: 30, eaten_at: Time.now - 2.days)
    user.save

    user.total_calories.must_equal 30
  end
end
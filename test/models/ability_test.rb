require "test_helper"

describe Ability do

  describe "for unauthenticated users" do
    let(:ability) { Ability.new(nil) }

    it "allows signing up" do
      ability.can?(:new, User).must_equal true
      ability.can?(:create, User).must_equal true
    end

    it "refuses access to dashboard" do
      ability.can?(:dashboard, Meal).must_equal false
    end
  end

  describe "for regular users" do
    let(:user) { FactoryGirl.build(:user, role: "regular") }
    let(:other_user) { FactoryGirl.build(:user, name: "User 1", email: "user1@example.com") }
    let(:ability) { Ability.new(user) }

    it "allows access to dashboard" do
      ability.can?(:dashboard, Meal).must_equal true
      ability.can?(:filter, Meal).must_equal true
      ability.can?(:new, Meal).must_equal true
      ability.can?(:create, Meal).must_equal true
    end

    it "allows editing and destroying own meals" do
      meal = FactoryGirl.build(:meal, user: user)

      ability.can?(:edit, meal).must_equal true
      ability.can?(:update, meal).must_equal true
      ability.can?(:destroy, meal).must_equal true
    end

    it "refuses editing and destroying meals of others" do
      meal = FactoryGirl.build(:meal, user: other_user)

      ability.can?(:edit, meal).must_equal false
      ability.can?(:update, meal).must_equal false
      ability.can?(:destroy, meal).must_equal false
    end

    it "allows accessing settings" do
      ability.can?(:settings, User).must_equal true
      ability.can?(:edit, User).must_equal true
      ability.can?(:update, User).must_equal true
    end

    it "refuses listing of users" do
      ability.can?(:index, User).must_equal false
    end

    it "refuses editing and deleting other users" do
      ability.can?(:edit, other_user).must_equal false
      ability.can?(:update, other_user).must_equal false
      ability.can?(:destroy, other_user).must_equal false
    end
  end

  describe "for user managers" do
    let(:user) { FactoryGirl.build(:user, role: "user_manager") }
    let(:other_user) { FactoryGirl.build(:user, name: "User 1", email: "user1@example.com") }
    let(:ability) { Ability.new(user) }

    it "allows listing of users" do
      ability.can?(:index, User).must_equal true
    end

    it "allows editing and deleting other users" do
      ability.can?(:edit, other_user).must_equal true
      ability.can?(:update, other_user).must_equal true
      ability.can?(:destroy, other_user).must_equal true
    end

    it "refuses deleting of self" do
      ability.can?(:destroy, user).must_equal false
    end

    it "refuses listing of meals" do
      ability.can?(:index, Meal).must_equal false
    end

    it "refuses updating of user roles" do
      ability.can?(:update_role_of, user).must_equal false
    end
  end

  describe "for admins" do
    let(:user) { FactoryGirl.build(:user, role: "admin") }
    let(:other_user) { FactoryGirl.build(:user, name: "User 1", email: "user1@example.com") }
    let(:ability) { Ability.new(user) }

    it "allows listing of meals" do
      ability.can?(:index, Meal).must_equal true
    end

    it "allows editing and deleting meals of others" do
      meal = FactoryGirl.build(:meal, user: other_user)

      ability.can?(:edit, meal).must_equal true
      ability.can?(:update, meal).must_equal true
      ability.can?(:destroy, meal).must_equal true
    end

    it "allows updating of user roles" do
      ability.can?(:update_role_of, user).must_equal true
    end
  end
end

require "test_helper"

describe MealsController do

  describe "for user managers" do
    let(:user) { FactoryGirl.create(:user, role: "user_manager") }
    let(:other_user) { FactoryGirl.create(:user, name: "User 1", email: "user1@example.com") }
    let(:meal) { FactoryGirl.create(:meal, user: other_user) }

    it "refuses updating meals of others" do
      session[:user_id] = user.id

      proc {
        put :update, id: meal.id
      }.must_raise CanCan::AccessDenied
    end
  end
end
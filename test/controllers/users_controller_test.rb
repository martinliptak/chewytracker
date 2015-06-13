require "test_helper"

describe UsersController do

  describe "for regular users" do
    let(:user) { FactoryGirl.create(:user, role: "regular") }
    let(:other_user) { FactoryGirl.create(:user, name: "User 1", email: "user1@example.com") }

    it "refuses updating other users" do
      session[:user_id] = user.id

      proc {
        put :update, id: other_user.id
      }.must_raise CanCan::AccessDenied
    end
  end

  describe "for user managers" do
    let(:user) { FactoryGirl.create(:user, role: "user_manager") }

    it "refuses updating user roles" do
      session[:user_id] = user.id

      put :update, id: user.id, user: { role: "admin" }
      
      user.reload
      user.role.must_equal "user_manager"
    end
  end
end
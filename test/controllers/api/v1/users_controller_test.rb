require "test_helper"

describe Api::V1::UsersController do
  let(:user) { FactoryGirl.create(:user, name: "User", email: "user@example.com") }
  let(:user_token) { FactoryGirl.create(:access_token, user: user) }

  let(:user_manager) { FactoryGirl.create(:user, name: "Admin", email: "user-manager@example.com", role: "user_manager") }
  let(:user_manager_token) { FactoryGirl.create(:access_token, user: user_manager) }

  let(:admin) { FactoryGirl.create(:user, name: "User", email: "admin@example.com", role: "admin") }
  let(:admin_token) { FactoryGirl.create(:access_token, user: admin) }

  describe :index do
    describe "for unauthenticated" do
      it "returns unauthorized" do
        get :index, format: :json

        response.status.must_equal 401
      end
    end

    describe "for regular user" do
      it "refuses to list all users" do
        get :index, token: user_token.name, format: :json

        response.status.must_equal 403
      end
    end

    describe "for user_manager" do
      it "shows alls users" do
        user

        get :index, token: user_manager_token.name, format: :json

        response.status.must_equal 200

        data = JSON.parse(response.body)
        data.must_be_kind_of Array
        data.count.must_equal 2
      end
    end
  end

  describe :show do
    describe "for regular user" do
      it "shows self" do
        get :show, token: user_token.name, id: user.id, format: :json

        response.status.must_equal 200

        data = JSON.parse(response.body)
        data.must_be_kind_of Hash
        data["id"].must_equal user.id
        data["name"].must_equal user.name
        data["email"].must_equal user.email
        data["expected_calories"].must_equal user.expected_calories
        data["role"].must_equal user.role
        data["created_at"].must_be :present?

        data["password_digest"].wont_be :present?
      end

      it "refuses to show other user" do
        get :show, token: user_token.name, id: user_manager.id, format: :json

        response.status.must_equal 403
      end

      it "fails if not found" do
        get :show, token: user_token.name, id: 10, format: :json

        response.status.must_equal 404
      end
    end

    describe "for user_manager" do
      it "shows other user" do
        get :show, token: user_manager_token.name, id: user.id, format: :json

        response.status.must_equal 200

        data = JSON.parse(response.body)
        data.must_be_kind_of Hash
        data["id"].must_equal user.id
        data["name"].must_equal user.name
        data["email"].must_equal user.email
        data["expected_calories"].must_equal user.expected_calories
        data["role"].must_equal user.role
        data["created_at"].must_be :present?
        data["password_digest"].wont_be :present?
      end
    end
  end

  describe :create do
    it "creates a user" do
      post :create, user: { name: "Garfield", email: "garfield@example.com", password: "secret", password_confirmation: "secret", expected_calories: 1000 }, format: :json

      response.status.must_equal 201

      User.count.must_equal 1

      user = User.last
      user.name.must_equal "Garfield"
      user.email.must_equal "garfield@example.com"
      user.expected_calories.must_equal 1000

      data = JSON.parse(response.body)
      data.must_be_kind_of Hash
      data["id"].must_equal user.id
      data["name"].must_equal user.name
      data["email"].must_equal user.email
      data["expected_calories"].must_equal user.expected_calories
      data["role"].must_equal user.role
      data["created_at"].must_be :present?
    end

    it "fails if parameters are missing" do
      post :create, format: :json

      response.status.must_equal 422

      User.count.must_equal 0
    end

    it "fails if required fields are missing" do
      post :create, user: { name: "Garfield" }, format: :json

      response.status.must_equal 422

      User.count.must_equal 0
    end
  end

  describe :update do
    describe "regular user" do
      it "updates self" do
        put :update, token: user_token.name, id: user.id, user: { name: "Garfield", email: "garfield@example.com", expected_calories: 1000 }, format: :json

        response.status.must_equal 204

        User.count.must_equal 1

        user.reload
        user.name.must_equal "Garfield"
        user.email.must_equal "garfield@example.com"
        user.expected_calories.must_equal 1000
      end

      it "refuses to update user" do
        put :update, token: user_token.name, id: user_manager.id, user: { name: "Garfield", email: "garfield@example.com", expected_calories: 1000 }, format: :json

        response.status.must_equal 403
      end

      it "fails if parameters are missing" do
        post :update, token: user_token.name, id: user.id, format: :json

        response.status.must_equal 422
      end
    end

    describe "user manager" do
      it "updates other user" do
        put :update, token: user_manager_token.name, id: user.id, user: { name: "Garfield", email: "garfield@example.com", expected_calories: 1000 }, format: :json

        response.status.must_equal 204

        User.count.must_equal 2

        user.reload
        user.name.must_equal "Garfield"
        user.email.must_equal "garfield@example.com"
        user.expected_calories.must_equal 1000
      end

      it "refuses to update user role" do
        put :update, token: user_manager_token.name, id: user_manager.id, user: { role: "admin" }, format: :json

        user_manager.reload
        user_manager.role.must_equal "user_manager"
      end
    end

    describe "admin" do
      it "updates user role" do
        put :update, token: admin_token.name, id: user_manager.id, user: { role: "admin" }, format: :json

        user_manager.reload
        user_manager.role.must_equal "admin"
      end
    end
  end

  describe :delete do
    describe "regular user" do
      it "destroys self" do
        delete :destroy, token: user_token.name, id: user.id, format: :json

        response.status.must_equal 403
      end

      it "refuses to destroy other user" do
        delete :destroy, token: user_token.name, id: user_manager.id, format: :json

        response.status.must_equal 403
      end
    end

    describe "user manager" do
      it "destroys self" do
        delete :destroy, token: user_manager_token.name, id: user_manager.id, format: :json

        response.status.must_equal 403
      end

      it "destroys other user" do
        delete :destroy, token: user_manager_token.name, id: user.id, format: :json

        response.status.must_equal 204

        User.count.must_equal 1
      end
    end
  end
end

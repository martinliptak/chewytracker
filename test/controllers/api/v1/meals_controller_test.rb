require "test_helper"

describe Api::V1::MealsController do
  let(:user) { FactoryGirl.create(:user, name: "User", email: "user@example.com") }
  let(:user_token) { FactoryGirl.create(:access_token, user: user) }
  let(:user_meal) { FactoryGirl.create(:meal, user: user) }
  let(:other_user_meal) { FactoryGirl.create(:meal, user: user, eaten_at: Time.now - 2.days) }

  let(:admin) { FactoryGirl.create(:user, name: "Admin", email: "admin@example.com", role: "admin") }
  let(:admin_token) { FactoryGirl.create(:access_token, user: admin) }
  let(:admin_meal) { FactoryGirl.create(:meal, user: admin) }

  describe :index do
    describe "for regular user" do
      describe "for unauthenticated" do
        it "returns unauthorized" do
          get :index, format: :json

          response.status.must_equal 401
        end
      end
    
      it "lists own meals" do
        user_meal
        other_user_meal
        admin_meal

        get :index, token: user_token.name, user_id: user.id, format: :json

        response.status.must_equal 200

        data = JSON.parse(response.body)
        data.must_be_kind_of Array
        data.count.must_equal 2
      end

      it "filters meals" do
        user_meal
        other_user_meal
        admin_meal

        get :index, token: user_token.name, date_from: Time.now, user_id: user.id, format: :json

        response.status.must_equal 200

        data = JSON.parse(response.body)
        data.must_be_kind_of Array
        data.count.must_equal 1
        data.first["id"].must_equal user_meal.id
      end

      it "refuses to lists all meals" do
        user_meal
        other_user_meal
        admin_meal

        get :index, token: user_token.name, format: :json

        response.status.must_equal 403
      end
    end

    describe "for admin" do
      it "lists all meals" do
        user_meal
        other_user_meal
        admin_meal

        get :index, token: admin_token.name, format: :json

        response.status.must_equal 200

        data = JSON.parse(response.body)
        data.must_be_kind_of Array
        data.count.must_equal 3
      end
    end
  end

  describe :show do
    describe "for regular user" do
      it "shows own meal" do
        get :show, token: user_token.name, id: user_meal.id, format: :json

        response.status.must_equal 200

        data = JSON.parse(response.body)
        data.must_be_kind_of Hash
        data["name"].must_equal user_meal.name
        data["calories"].must_equal user_meal.calories
        data["eaten_at"].must_be :present?
      end

      it "refuses to show a meal of other user" do
        get :show, token: user_token.name, id: admin_meal.id, format: :json

        response.status.must_equal 403
      end

      it "fails if not found" do
        get :show, token: user_token.name, id: 10, format: :json

        response.status.must_equal 404
      end
    end

    describe "for admin" do
      it "shows a meal of other user" do
        get :show, token: admin_token.name, id: user_meal.id, format: :json

        response.status.must_equal 200

        data = JSON.parse(response.body)
        data.must_be_kind_of Hash
        data["name"].must_equal user_meal.name
        data["calories"].must_equal user_meal.calories
        data["eaten_at"].must_be :present?
      end
    end
  end

  describe :create do
    it "creates a meal" do
      post :create, token: user_token.name, meal: { name: "New meal", calories: 100, eaten_at: Date.today }, format: :json

      response.status.must_equal 201

      Meal.count.must_equal 1

      meal = Meal.last
      meal.name.must_equal "New meal"
      meal.calories.must_equal 100
      meal.eaten_at.must_be :present?
      meal.user.must_equal user

      data = JSON.parse(response.body)
      data.must_be_kind_of Hash
      data["name"].must_equal meal.name
      data["calories"].must_equal meal.calories
      data["eaten_at"].must_be :present?
    end

    it "fails if parameters are missing" do
      post :create, token: user_token.name, format: :json

      response.status.must_equal 422

      Meal.count.must_equal 0
    end

    it "fails if required fields are missing" do
      post :create, token: user_token.name, meal: { name: "New meal", eaten_at: Date.today }, format: :json

      response.status.must_equal 422

      Meal.count.must_equal 0
    end
  end

  describe :update do
    describe "regular user" do
      it "updates own meal" do
        put :update, token: user_token.name, id: user_meal, meal: { name: "New meal", calories: 100, eaten_at: Date.today }, format: :json

        response.status.must_equal 204

        Meal.count.must_equal 1

        meal = Meal.last
        meal.name.must_equal "New meal"
        meal.calories.must_equal 100
        meal.eaten_at.must_be :present?
        meal.user.must_equal user
      end

      it "refuses to update a meal of other user" do
        put :update, token: user_token.name, id: admin_meal, meal: { name: "New meal", calories: 100, eaten_at: Date.today }, format: :json

        response.status.must_equal 403
      end

      it "fails if parameters are missing" do
        post :update, token: user_token.name, id: user_meal, format: :json

        response.status.must_equal 422
      end
    end

    describe "admin" do
      it "updates meal of other user" do
        put :update, token: admin_token.name, id: user_meal, meal: { name: "New meal", calories: 100, eaten_at: Date.today }, format: :json

        response.status.must_equal 204

        Meal.count.must_equal 1

        meal = Meal.last
        meal.name.must_equal "New meal"
        meal.calories.must_equal 100
        meal.eaten_at.must_be :present?
        meal.user.must_equal user
      end
    end
  end

  describe :delete do
    describe "regular user" do
      it "destroys own meal" do
        delete :destroy, token: user_token.name, id: user_meal, format: :json

        response.status.must_equal 204

        Meal.count.must_equal 0
      end

      it "refuses to destroy a meal of other user" do
        delete :destroy, token: user_token.name, id: admin_meal, format: :json

        response.status.must_equal 403
      end
    end

    describe "admin" do
      it "destroys meal of other user" do
        delete :destroy, token: admin_token.name, id: user_meal, format: :json

        response.status.must_equal 204

        Meal.count.must_equal 0
      end
    end
  end
end

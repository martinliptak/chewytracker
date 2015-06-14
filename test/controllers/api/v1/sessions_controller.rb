require "test_helper"

describe Api::V1::SessionsController do
  let(:user) { FactoryGirl.create(:user) }

  describe :show do
    it "returns unauthenticated status" do
      get :show, format: :json

      response.status.must_equal 200

      data = JSON.parse(response.body)
      data.must_be_kind_of Hash
      data["status"].must_equal "unauthenticated"
    end

    it "returns authenticated status and current user details" do
      session[:api_v1_user_id] = user.id

      get :show, format: :json

      response.status.must_equal 200

      data = JSON.parse(response.body)
      data.must_be_kind_of Hash
      data['status'].must_equal "authenticated"
      data['user'].must_be_kind_of Hash
      data['user']['id'].must_equal user.id
      data['user']['role'].must_equal user.role
    end

    describe "with custom fields" do
      it "returns authenticated status and current user details" do
        session[:api_v1_user_id] = user.id

        get :show, include: [:id, :name, :email, :expected_calories, :role, :created_at, :updated_at], format: :json

        response.status.must_equal 200

        data = JSON.parse(response.body)
        data.must_be_kind_of Hash
        data['status'].must_equal "authenticated"
        data['user'].must_be_kind_of Hash
        data['user']['id'].must_equal user.id
        data['user']['role'].must_equal user.role
        data['user']['name'].must_equal user.name
        data['user']['email'].must_equal user.email
        data['user']['expected_calories'].must_equal user.expected_calories
        data['user']['created_at'].must_be :present?
        data['user']['updated_at'].must_be :present?
      end
    end

    describe "with unknown custom fields" do
      it "fails" do
        session[:api_v1_user_id] = user.id

        get :show, include: [:id, :name, :email, :password_digest], format: :json

        response.status.must_equal 400

        data = JSON.parse(response.body)
        data.must_be_kind_of Hash
        data['user'].wont_be_kind_of Hash
      end
    end
  end

  describe :create do
    describe "with correct credentials" do
      it "creates session" do
        post :create, session: { email: user.email, password: user.password }, format: :json

        response.status.must_equal 200

        session[:api_v1_user_id].must_equal user.id
      end
    end

    describe "with correct credentials but unknown fields" do
      it "creates session" do
        post :create, session: { email: user.email, password: user.password }, include: [:email, :password_digest], format: :json

        response.status.must_equal 400

        session[:api_v1_user_id].wont_equal user.id
      end
    end

    describe "with incorrect credentials" do
      it "fails" do
        post :create, session: { email: user.email, password: user.password + "-incorrect" }, format: :json

        response.status.must_equal 401

        session[:api_v1_user_id].wont_equal user.id
      end
    end

    describe "with unprocessable entity" do
      it "fails" do
        post :create, format: :json

        response.status.must_equal 422

        session[:api_v1_user_id].wont_equal user.id
      end
    end
  end

  describe :destroy do
    it "destroys session" do
      delete :destroy, format: :json

      response.status.must_equal 200

      session[:api_v1_user_id].must_be_nil
    end
  end
end

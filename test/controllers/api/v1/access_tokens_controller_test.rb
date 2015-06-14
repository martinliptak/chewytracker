require "test_helper"

describe Api::V1::AccessTokensController do
  let(:user) { FactoryGirl.create(:user) }
  let(:access_token) { FactoryGirl.create(:access_token, user: user) }

  describe :show do
    it "shows access token" do
      get :show, name: access_token.name, format: :json

      response.status.must_equal 200

      data = JSON.parse(response.body)
      data.must_be_kind_of Hash
      data["name"].must_equal access_token.name
      data["user_id"].must_equal access_token.user_id
      data["expires_at"].must_be :present?
    end

    it "fails if not found" do
      get :show, name: access_token.name + "-doesnt-exist", format: :json

      response.status.must_equal 404
    end
  end

  describe :create do
    describe "with correct credentials" do
      it "creates access token" do
        post :create, credentials: { email: user.email, password: user.password }, format: :json

        response.status.must_equal 201

        AccessToken.count.must_equal 1
        AccessToken.last.user.must_equal user

        data = JSON.parse(response.body)
        data.must_be_kind_of Hash
        data["name"].must_equal AccessToken.last.name
        data["user_id"].must_equal user.id
        data["expires_at"].must_be :present?
      end
    end

    describe "with incorrect credentials" do
      it "fails" do
        post :create, credentials: { email: user.email, password: user.password + "-incorrect" }, format: :json

        response.status.must_equal 401

        AccessToken.count.must_equal 0
      end
    end
  end

  describe :delete do
    it "destroys access token" do
      delete :destroy, name: access_token.name, format: :json

      response.status.must_equal 204

      AccessToken.count.must_equal 0
    end

    it "fails if not found" do
      delete :destroy, name: access_token.name + "-doesnt-exist", format: :json

      response.status.must_equal 404
    end
  end
end

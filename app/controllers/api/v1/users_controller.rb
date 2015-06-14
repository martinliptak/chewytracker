module Api
  module V1
    class UsersController < BaseController
      before_action :authenticate!, except: :create
      load_and_authorize_resource

      # Don't expose fields like password_digest
      EXPOSED_FIELDS = [:id, :name, :email, :role, :created_at, :updated_at]
      EXPOSED_METHODS = [:expected_calories]

      ##
      #
      # GET /api/v1/users/
      #
      # params:
      #   token - current user authorization
      #
      # returns:
      #   200 - success
      #   401 - unauthorized
      #   403 - forbidden
      #    
      # = Examples
      #
      #   resp = conn.get "/api/v1/users", token: "25be778dc2ed161b63eb07684d45a561"
      #   resp.status
      #   => 200
      #   resp.body
      #   => [{"id"=>1,"name"=>"Hungry Joe","email"=>"joe@example.com","role"=>"admin","created_at"=>"2015-06-28T13:23:33.525Z","updated_at"=>"2015-06-28T13:23:33.525Z"}, ...]
      #
      def index
        render json: @users.order("id DESC").to_json(only: EXPOSED_FIELDS)
      end

      ##
      #
      # GET /api/v1/users/:id
      #
      # params:
      #   token - current user authorization
      #
      # returns:
      #   200 - success
      #   401 - unauthorized
      #   403 - forbidden
      #   404 - not found
      #    
      # = Examples
      #
      #   resp = conn.get "/api/v1/users/20", token: "25be778dc2ed161b63eb07684d45a561"
      #   resp.status
      #   => 200
      #   resp.body
      #   => {"name"=>"Double Cheese Burger","calories"=>1000000,"eaten_at"=>"2015-06-28T13:23:33.525Z"}
      #
      def show
        render json: @user.to_json(only: EXPOSED_FIELDS, methods: EXPOSED_METHODS)
      end

      ##
      #
      # POST /api/v1/users
      # 
      # params:
      #   user (Hash)
      #   token - current user authorization
      #
      # returns:
      #   201 - success
      #   401 - unauthorized
      #   422 - wrong parameters
      #    
      # = Examples
      #
      #   resp = conn.post "/api/v1/users", user: { name: "Double Cheese Burger", calories: "1000000", eaten_at: "2015-06-28T13:23:33.525Z"}, token: "25be778dc2ed161b63eb07684d45a561"
      #   resp.status
      #   => 201
      #   resp.body
      #   => {"name"=>"Double Cheese Burger","calories"=>1000000,"eaten_at"=>"2015-06-28T13:23:33.525Z"}
      #
      def create
        @user.save!
        
        render json: @user.to_json(only: EXPOSED_FIELDS, methods: EXPOSED_METHODS), status: :created
      end

      ##
      #
      # PUT /api/v1/users/:id
      # 
      # params:
      #   user (Hash)
      #   token - current user authorization
      #
      # returns:
      #   204 - success
      #   401 - unauthorized
      #   403 - forbidden
      #   422 - wrong parameters
      #
      def update
        @user.update_attributes!(user_params)
        
        render nothing: true, status: :no_content
      end
      
      ##
      #
      # DELETE /api/v1/users/:id
      # 
      # params:
      #   token - current user authorization
      #
      # returns:
      #   204 - success
      #   401 - unauthorized
      #   403 - forbidden
      #
      def destroy
        @user.destroy!

        render nothing: true, status: :no_content
      end

      private

        def user_params
          p = []
          p += [:name, :email, :password, :password_confirmation, :expected_calories]
          p += [:role] if can?(:update_role_of, User)
          params.require(:user).permit(p)
        end
    end
  end
end
module Api
  module V1
    class AccessTokensController < BaseController
      before_action :find_access_token, only: [:show, :destroy]

      ##
      #
      # GET /api/v1/access_tokens/:name
      #
      # returns:
      #   200 - success
      #   404 - not found
      #    
      # = Examples
      #
      #   resp = conn.get "/api/v1/access_tokens/25be778dc2ed161b63eb07684d45a561"
      #   resp.status
      #   => 200
      #   resp.body
      #   => {"name"=>"25be778dc2ed161b63eb07684d45a561","user_id"=>149,"expires_at"=>"2015-06-28T13:23:33.525Z"}
      #
      def show
        render :json => @access_token.to_json(only: [:name, :user_id, :expires_at])
      end
      
      ##
      # Use this action to authenticate users. If the provided credentials are correct, an access token is generated. 
      #
      # POST /api/v1/access_tokens
      # 
      # params:
      #   credentials (Hash) - user credentials
      #
      # returns:
      #   201 - success, remember the access token name
      #   401 - incorrect email or password
      #   422 - wrong parameters
      #    
      # = Examples
      #
      #   resp = conn.post "/api/v1/access_tokens", credentials: {email: "john@example.com", password: "password"}
      #   resp.status
      #   => 200
      #   resp.body
      #   => {"name"=>"25be778dc2ed161b63eb07684d45a561","user_id"=>149,"expires_at"=>"2015-06-28T13:23:33.525Z"}
      #
      def create
        user = User.find_by_email(create_params[:email])
        if user && user.authenticate(create_params[:password])
          render :json => AccessToken.create!(user: user), :status => :created
        else
          render :json => { message: "Incorrect credentials" }, :status => :unauthorized
        end
      end
      
      ##
      # Use this action to end user sessions.
      #
      # DELETE /api/v1/access_tokens/:name
      #
      # returns:
      #   204 - success
      #
      def destroy
        @access_token.destroy
        render nothing: true, status: :no_content
      end

      private

        def create_params
          params.require(:credentials).permit(:email, :password)
        end

        def find_access_token
          @access_token = AccessToken.where(name: params[:name]).first!
        end
    end
  end
end
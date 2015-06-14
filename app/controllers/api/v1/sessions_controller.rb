module Api
  module V1
    class SessionsController < BaseController
      DEFAULT_USER_FIELDS = [:id, :role]
      EXPOSED_USER_FIELDS = [:id, :name, :email, :expected_calories, :role, :created_at, :updated_at]
      
      before_action only: [:show, :create] do
        check_fields! DEFAULT_USER_FIELDS, EXPOSED_USER_FIELDS
      end

      ##
      # Returns authentication status and basic user info
      #
      # GET /api/v1/session
      #
      # params:
      #   include - user fields to be returned if authenticated (available: id, name, :email, expected_calories, role, created_at, updated_at)
      #
      # returns:
      #   200 - success
      #   400 - unknown fields in the include parameter
      #    
      # = Examples
      #
      #   resp = conn.get "/api/v1/session"
      #   resp.status
      #   => 200
      #   resp.body
      #   => {"status":"unauthenticated"}
      #
      #   resp = conn.get "/api/v1/session", include: ["id", "name", "expected_calories"]
      #   resp.status
      #   => 200
      #   resp.body
      #   => {"status":"authenticated","user":{"id"=>123,"name"=>"John Doe","expected_calories"=>2000}}
      #
      def show
        response = {}
        if current_user
          response[:status] = "authenticated"
          response[:user] = extract_fields(current_user, DEFAULT_USER_FIELDS, EXPOSED_USER_FIELDS)
        else
          response[:status] = "unauthenticated"
        end
        render :json => response
      end
      
      ##
      # Signs the user in
      #
      # POST /api/v1/session
      # 
      # params:
      #   session (Hash) - user credentials
      #   include (Array) - user fields to be returned if authenticated (available: id, name, :email, expected_calories, role, created_at, updated_at)
      #
      # returns:
      #   200 - the user is signed in, remember the cookie
      #   400 - unknown fields in the include parameter
      #   401 - incorrect email or password
      #   422 - wrong parameters
      #    
      # = Examples
      #
      #   resp = conn.post "/api/v1/session", session: {email: "john@example.com", password: "password"}, include: ["id", "name", "expected_calories"]
      #   resp.status
      #   => 200
      #   resp.body
      #   => {"user":{"id"=>123,"name"=>"John Doe","expected_calories"=>2000}}
      #
      def create
        user = User.find_by_email(session_params[:email])
        if user && user.authenticate(session_params[:password])
          session[:api_v1_user_id] = user.id
          render :json => { user: extract_fields(current_user, DEFAULT_USER_FIELDS, EXPOSED_USER_FIELDS) }
        else
          render :json => { message: "Incorrect credentials" }, :status => :unauthorized
        end
      end
      
      ##
      # Signs the user out
      #
      # DELETE /api/v1/session
      # 
      # returns:
      #   200 - the user is signed out
      #    
      # = Examples
      #
      #   resp = conn.delete "/api/v1/session"
      #   resp.status
      #   => 200
      #
      def destroy
        session[:api_v1_user_id] = nil
        render nothing: true
      end

      private

        def session_params
          params.require(:session).permit(:email, :password)
        end
    end
  end
end
module Api
  module V1
    class BaseController < ActionController::Base
      # Prevent CSRF attacks by raising an exception.
      # For APIs, you may want to use :null_session instead.
      protect_from_forgery with: :null_session

      private

        # Call from before actions if required
        def authenticate!
          access_token = AccessToken.where(name: params[:token]).first
          if access_token && !access_token.expired?
            @current_user = access_token.user
          else
            render :json => { message: "Unauthorized" }, :status => :unauthorized 
            false
          end
        end

        def current_user
          @current_user
        end

        # Responses for exceptions

        rescue_from ActiveRecord::RecordNotFound do |exception|
          render :json => { message: "Not found" }, :status => :not_found
        end

        rescue_from ActiveRecord::RecordInvalid do |exception|
          render :json => { message: "Unprocessable entity" }, :status => :unprocessable_entity
        end

        rescue_from ActionController::ParameterMissing do |exception|
          render :json => { message: "Unprocessable entity" }, :status => :unprocessable_entity
        end

        rescue_from CanCan::AccessDenied do |exception|
          render :json => { message: "Forbidden" }, :status => :forbidden
        end
    end
  end
end

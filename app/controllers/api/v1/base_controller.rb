module Api
  module V1
    class BaseController < ActionController::Base
      # Prevent CSRF attacks by raising an exception.
      # For APIs, you may want to use :null_session instead.
      protect_from_forgery with: :null_session

      private

        def current_user
          @current_user ||= User.find(session[:api_v1_user_id]) if session[:api_v1_user_id]
        end 

        class BadRequest < StandardError
        end
        
        rescue_from BadRequest do |exception|
          render :json => { message: exception.message }, :status => :bad_request
        end

        def included_fields(default_fields)
          params[:include].kind_of?(Array) ? params[:include] : default_fields
        end

        def check_fields!(default_fields, exposed_fields)
          unknown_fields = included_fields(default_fields).map(&:to_s) - exposed_fields.map(&:to_s)
          if unknown_fields.any?
            raise BadRequest.new("Unknown fields: #{unknown_fields.join(", ")}") 
          end
        end

        def extract_fields(object, default_fields, exposed_fields)
          (included_fields(default_fields).map(&:to_s) & exposed_fields.map(&:to_s)).map { |field| 
            [field, object.send(field)] 
          }.to_h
        end

        rescue_from ActionController::ParameterMissing do |exception|
          render :json => { message: "Unprocessable entity" }, :status => :unprocessable_entity
        end
    end
  end
end

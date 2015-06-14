module Api
  module V1
    class UsersController < BaseController
      respond_to :json
      
      def index
        @users = User.select(:id, :name, :role, :created_at).all
      end
      
      def show
        @user = User.select(:id, :name, :email, :role, :settings, :created_at).find(params[:id])
      end
      
      def create
        respond_with User.create(params[:user])
      end
      
      def update
        respond_with User.update(params[:id], params[:users])
      end
      
      def destroy
        respond_with User.destroy(params[:id])
      end
    end
  end
end
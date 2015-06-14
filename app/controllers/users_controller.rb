class UsersController < ApplicationController
  before_action :authenticate!, only: [:settings, :edit, :update, :destroy]
  
  load_and_authorize_resource 

  def index
    @users = User.order("id DESC")
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_via_turbolinks_to dashboard_path
    end
  end

  def settings
    @user = current_user
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      redirect_via_turbolinks_to request.referer && URI(request.referer).path == settings_path ? dashboard_path : users_path
    end
  end

  def destroy
    @user.destroy
    redirect_via_turbolinks_to users_path
  end

  private

    def user_params
      p = []
      p += [:name, :email, :password, :password_confirmation, :expected_calories]
      p += [:role] if can?(:update_role_of, User)
      params.require(:user).permit(p)
    end
end
class UsersController < ApplicationController
  before_action :authenticate!, except: [:new, :create]
  
  load_and_authorize_resource 

  def index
    @users = User.page(params[:page])

    session[:return_to] = users_path
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

    session[:return_to] = dashboard_path
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      redirect_via_turbolinks_to (session[:return_to] || dashboard_path), notice: t("users.messages.update", name: @user.name)
    end
  end

  def destroy
    @user.destroy
    redirect_via_turbolinks_to users_path, notice: t("users.messages.destroy", name: @user.name)
  end

  private

    def user_params
      p = []
      p += [:name, :email, :password, :password_confirmation, :expected_calories]
      p += [:role] if can?(:update_role_of, User)
      params.require(:user).permit(p)
    end
end
class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user_parameters = params.require(:user).permit(:name, :email, :password, :password_confirmation)
    @user = User.new(user_parameters)
    if @user.save
      session[:user_id] = @user.id
      redirect_via_turbolinks_to dashboard_path
    end
  end
end
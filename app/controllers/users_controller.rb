class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user_parameters = params.require(:user).permit(:name, :email, :password, :password_confirmation)
    @user = User.new(user_parameters)
    @user.role = "regular"
    if @user.save
      redirect_to root_url, notice: "Thank you for signing up!"
    end
  end
end
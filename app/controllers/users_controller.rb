class UsersController < ApplicationController
  before_action :authenticate!, only: [:edit, :update, :destroy]

  before_action :find_user, only: [:edit, :update, :destroy]
  before_action :authorize!, only: [:edit, :update, :destroy]

  def index
    @users = User.order("id DESC")
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_parameters)
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
    if @user.update_attributes(user_parameters)
      redirect_via_turbolinks_to URI(request.referer).path == settings_path ? dashboard_path : users_path
    end
  end

  def destroy
    @user.delete
    redirect_via_turbolinks_to users_path
  end

  private

    def find_user
      @user = User.find(params[:id])
    end

    def authorize!
      # todo
    end

    def user_parameters
      p = []
      p += [:name, :email, :password, :password_confirmation, :expected_calories]
      params.require(:user).permit(p)
    end
end
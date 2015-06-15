class MealsController < ApplicationController
  before_action :authenticate!
  
  load_and_authorize_resource

  def index
    @meals = Meal
      .filter(params.slice(:filter_user_id))
      .page(params[:page])

    session[:return_to] = meals_path
  end

  def new
    @meal = Meal.new
  end

  def create
    @meal = Meal.new(meal_params)
    @meal.user = current_user
    if @meal.save
      redirect_via_turbolinks_to :dashboard, notice: t("meals.messages.create")
    end
  end

  def edit
  end

  def update
    if @meal.update_attributes(meal_params)
      redirect_via_turbolinks_to (session[:return_to] || dashboard_path), notice: t("meals.messages.update", name: @meal.name)
    end
  end

  def destroy
    @meal.destroy
    redirect_via_turbolinks_to (session[:return_to] || dashboard_path), notice: t("meals.messages.destroy", name: @meal.name)
  end

  private

    def meal_params
      params.require(:meal).permit(:name, :calories, :eaten_at)
    end
end
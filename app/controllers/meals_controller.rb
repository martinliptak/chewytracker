class MealsController < ApplicationController
  before_action :authenticate!
  
  load_and_authorize_resource

  def dashboard
    @meals = current_user.meals.page(params[:page])
    @meals = @meals.date_from(params[:filter_date_from]) if params[:filter_date_from].present?
    @meals = @meals.date_to(params[:filter_date_to]) if params[:filter_date_to].present?
    @meals = @meals.time_from(params[:filter_time_from]) if params[:filter_time_from].present?
    @meals = @meals.time_to(params[:filter_time_to]) if params[:filter_time_to].present?

    session[:from] = :dashboard
  end

  def index
    @meals = Meal.page params[:page]
    @meals = @meals.user_id(params[:filter_user_id]) if params[:filter_user_id].present?

    session[:from] = :index
  end

  def new
    @meal = Meal.new
  end

  def create
    @meal = Meal.new(meal_params)
    @meal.user = current_user
    if @meal.save
      redirect_via_turbolinks_to :dashboard
    end
  end

  def edit
  end

  def update
    if @meal.update_attributes(meal_params)
      redirect_via_turbolinks_to action: session[:from]
    end
  end

  def destroy
    @meal.destroy
    redirect_via_turbolinks_to action: session[:from]
  end

  private

    def meal_params
      params.require(:meal).permit(:name, :calories, :eaten_at)
    end
end
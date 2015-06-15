class MealsController < ApplicationController
  before_action :authenticate!
  
  load_and_authorize_resource

  def dashboard
    @meals = current_user.meals.order("eaten_at DESC").page params[:page]
    session[:from] = :dashboard
  end

  def index
    @meals = Meal.order("eaten_at DESC").page params[:page]
    session[:from] = :index
  end

  def filter
    @meals = current_user.meals.order("eaten_at DESC").page params[:page]
    @meals.where!("eaten_at::date >= ?", params[:filter_date_from]) if params[:filter_date_from].present?
    @meals.where!("eaten_at::date <= ?", params[:filter_date_to]) if params[:filter_date_to].present?
    @meals.where!("eaten_at::time >= ?", params[:filter_time_from]) if params[:filter_time_from].present?
    @meals.where!("eaten_at::time <= ?", params[:filter_time_to]) if params[:filter_time_to].present?
  end

  def filter_all
    @meals = Meal.order("eaten_at DESC").page params[:page]
    @meals.where!("user_id = ?", params[:filter_user_id]) if params[:filter_user_id].present?

    render :filter
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
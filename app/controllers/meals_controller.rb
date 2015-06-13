class MealsController < ApplicationController
  before_action :authenticate!
  before_action :find_meal, only: [:edit, :update, :destroy]

  def dashboard
    @meals = current_user.meals.order("id DESC")
    session[:from] = :dashboard
  end

  def index
    @meals = Meal.order("id DESC")
    session[:from] = :index
  end

  def filter
    @meals = current_user.meals.order("id DESC")
    @meals.where!("eaten_at::date >= ?", params[:filter_date_from]) if params[:filter_date_from].present?
    @meals.where!("eaten_at::date <= ?", params[:filter_date_to]) if params[:filter_date_to].present?
    @meals.where!("eaten_at::time >= ?", params[:filter_time_from]) if params[:filter_time_from].present?
    @meals.where!("eaten_at::time <= ?", params[:filter_time_to]) if params[:filter_time_to].present?
  end

  def filter_all
    @meals = Meal.order("id DESC")
    @meals.where!("user_id = ?", params[:filter_user_id]) if params[:filter_user_id].present?

    render :filter
  end

  def new
    @meal = Meal.new
  end

  def create
    @meal = Meal.new(meal_parameters)
    @meal.user = current_user
    if @meal.save
      redirect_via_turbolinks_to :dashboard
    end
  end

  def edit
  end

  def update
    if @meal.update_attributes(meal_parameters)
      redirect_via_turbolinks_to action: session[:from]
    end
  end

  def destroy
    @meal.delete
    redirect_via_turbolinks_to action: session[:from]
  end

  private

    def meal_parameters
      params.require(:meal).permit(:name, :calories, :eaten_at)
    end

    def find_meal
      @meal = Meal.find(params[:id])
    end
end
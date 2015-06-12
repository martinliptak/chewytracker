class MealsController < ApplicationController
  before_action :authorize!
  before_action :find_meal, only: [:edit, :update, :destroy]

  def index
    @meals = current_user.meals.order("eaten_at DESC")
  end

  def filter
    @meals = current_user.meals.order("eaten_at DESC")
    @meals.where!("eaten_at::date >= ?", params[:filter_date_from]) if params[:filter_date_from].present?
    @meals.where!("eaten_at::date <= ?", params[:filter_date_to]) if params[:filter_date_to].present?
    @meals.where!("eaten_at::time >= ?", params[:filter_time_from]) if params[:filter_time_from].present?
    @meals.where!("eaten_at::time <= ?", params[:filter_time_to]) if params[:filter_time_to].present?
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
      redirect_via_turbolinks_to :dashboard
    end
  end

  def destroy
    @meal.delete
    redirect_via_turbolinks_to :dashboard
  end

  private

    def meal_parameters
      params.require(:meal).permit(:name, :calories, :eaten_at)
    end

    def find_meal
      @meal = current_user.meals.find(params[:id])
    end
end
class MealsController < ApplicationController
  before_action :authenticate!
  
  load_and_authorize_resource except: :index

  def index
    authorize! :index, Meal

    @meals = Meal.page params[:page]
    @meals = @meals.user_id(params[:filter_user_id]) if params[:filter_user_id].present?

    session[:return_to] = meals_path
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
      redirect_via_turbolinks_to session[:return_to] || dashboard_path
    end
  end

  def destroy
    @meal.destroy
    redirect_via_turbolinks_to session[:return_to] || dashboard_path
  end

  private

    def meal_params
      params.require(:meal).permit(:name, :calories, :eaten_at)
    end
end
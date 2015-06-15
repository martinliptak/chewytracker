class DashboardController < ApplicationController
  before_action :authenticate!

  def index
    authorize! :index_owned, Meal

    @meals = current_user.meals.page(params[:page])
    @meals = @meals.date_from(params[:filter_date_from]) if params[:filter_date_from].present?
    @meals = @meals.date_to(params[:filter_date_to]) if params[:filter_date_to].present?
    @meals = @meals.time_from(params[:filter_time_from]) if params[:filter_time_from].present?
    @meals = @meals.time_to(params[:filter_time_to]) if params[:filter_time_to].present?

    @total_calories = current_user.total_calories
    @expected_calories = current_user.expected_calories

    session[:return_to] = dashboard_path
  end
end
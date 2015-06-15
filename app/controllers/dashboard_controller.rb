class DashboardController < ApplicationController
  before_action :authenticate!

  def index
    authorize! :index_owned, Meal

    @meals = current_user.meals
      .filter(params.slice(:filter_date_from, :filter_date_to, :filter_time_from, :filter_time_to))
      .page(params[:page])

    @total_calories = current_user.total_calories
    @expected_calories = current_user.expected_calories

    session[:return_to] = dashboard_path
  end
end
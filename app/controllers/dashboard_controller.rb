class DashboardController < ApplicationController
  before_action :authenticate!

  def index
    authorize! :index_owned, Meal

    @dashboard = Dashboard.new(current_user, params)

    session[:return_to] = dashboard_path
  end
end
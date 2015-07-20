class Dashboard
  attr_reader :user, :params

  def initialize(user, params)
    @user = user
    @params = params
  end

  def meals
    @_meals ||= user.meals
      .filter(params.slice(:filter_date_from, :filter_date_to, :filter_time_from, :filter_time_to))
      .page(params[:page])
  end

  def total_calories
    @_total_calories ||= user.meals.where("eaten_at::date = current_date").sum(:calories)
  end
  
  def total_calories_percent
    [100, (total_calories.to_f / expected_calories) * 100].min
  end

  def total_calories_exceeded
    total_calories > expected_calories
  end

  def expected_calories
    @_expected_calories ||= user.expected_calories
  end
end

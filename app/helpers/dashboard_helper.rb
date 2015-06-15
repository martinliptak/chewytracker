module DashboardHelper
  def total_calories_percent
    [100, (@total_calories.to_f / @expected_calories) * 100].min
  end

  def total_calories_exceeded
    @total_calories > @expected_calories
  end
end

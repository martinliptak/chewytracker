module MealsHelper
  def total_calories_percent
    [100, (current_user.total_calories.to_f / current_user.expected_calories) * 100].min
  end

  def total_calories_exceeded
    current_user.total_calories > current_user.expected_calories
  end
end

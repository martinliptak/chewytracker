require "test_helper"

feature "Meals" do
  scenario "are listed", js: true do
    create_user_and_sign_in

    page.must_have_content "There aren't any meals yet."

    current_user.meals.create!(name: "Meal 1", calories: 100, eaten_at: Time.now)
    current_user.meals.create!(name: "Meal 2", calories: 200, eaten_at: Time.now - 2.days)
    visit dashboard_path

    page.must_have_content "Meal 1"
    page.must_have_content "Meal 2"
    page.must_have_content "100"
    page.must_have_content "200"
  end

  scenario "are filtered", js: true do
    create_user_and_sign_in

    current_user.meals.create!(name: "Meal 1", calories: 100, eaten_at: Time.now)
    current_user.meals.create!(name: "Meal 2", calories: 200, eaten_at: Time.now - 2.days)
    visit dashboard_path

    fill_in :filter_date_from, with: Date.today.to_formatted_s(:iso8601) # just the latest meal
    click_button "Apply"

    page.must_have_content "Meal 1"
    page.wont_have_content "Meal 2"

    click_link "clear filters"

    page.must_have_content "Meal 1"
    page.must_have_content "Meal 2"
  end

  scenario "are added", js: true do
    create_user_and_sign_in

    click_link "Add new meal"

    fill_in :meal_name, with: "New meal"
    fill_in :meal_calories, with: "1000"
    fill_in :meal_eaten_at, with: "2015-06-12T12:00:00"
    click_button "Save"

    page.must_have_content "My meals"

    Meal.count.must_equal 1

    meal = Meal.last
    meal.name.must_equal "New meal"
    meal.calories.must_equal 1000
    meal.eaten_at.must_equal Time.parse("Fri, 12 Jun 2015 12:00:00 UTC +00:00")
  end

  scenario "are edited", js: true do
    create_user_and_sign_in

    current_user.meals.create!(name: "Meal 1", calories: 100, eaten_at: Time.now)
    visit dashboard_path

    within "#meals" do
      click_link "Edit"
    end

    fill_in :meal_name, with: "New meal"
    fill_in :meal_calories, with: "1000"
    fill_in :meal_eaten_at, with: "2015-06-12T12:00:00"
    click_button "Save"

    page.must_have_content "My meals"

    Meal.count.must_equal 1

    meal = Meal.last
    meal.name.must_equal "New meal"
    meal.calories.must_equal 1000
    meal.eaten_at.must_equal Time.parse("Fri, 12 Jun 2015 12:00:00 UTC +00:00")
  end

  scenario "are removed", js: true do
    create_user_and_sign_in

    current_user.meals.create!(name: "Meal 1", calories: 100, eaten_at: Time.now)
    visit dashboard_path

    within "#meals" do
      click_link "Remove"
    end

    page.must_have_content "My meals"

    Meal.count.must_equal 0
  end
end
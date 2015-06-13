require "test_helper"

feature "Managing meals" do
  scenario "Listing all meals", js: true do
    other_user = create_user(name: "User 1", email: "user1@example.com")

    create_user_and_sign_in

    click_link "Manage"
    click_link "Meals"
    current_path.must_equal meals_path

    page.must_have_content "There aren't any meals yet."

    current_user.meals.create!(name: "Meal 1", calories: 100, eaten_at: Time.now)
    other_user.meals.create!(name: "Meal 2", calories: 200, eaten_at: Time.now - 2.days)
    visit meals_path

    page.must_have_content "Meal 1"
    page.must_have_content "Meal 2"
    page.must_have_content "100"
    page.must_have_content "200"
    page.must_have_content "User 1"
  end

  scenario "Filtering all meals", js: true do
    other_user = create_user(name: "User 1", email: "user1@example.com")

    create_user_and_sign_in

    current_user.meals.create!(name: "Meal 1", calories: 100, eaten_at: Time.now)
    other_user.meals.create!(name: "Meal 2", calories: 200, eaten_at: Time.now - 2.days)

    visit meals_path

    select other_user.name, from: :_filter_user_id
    click_button "Apply"

    page.must_have_content "Meal 2"
    page.wont_have_content "Meal 1"

    click_link "clear filters"

    page.must_have_content "Meal 1"
    page.must_have_content "Meal 2"
  end

  scenario "Editing meals", js: true do
    other_user = create_user(name: "User 1", email: "user1@example.com")
    other_user.meals.create!(name: "Meal 1", calories: 100, eaten_at: Time.now)

    create_user_and_sign_in

    visit meals_path

    within "#meals" do
      click_link "Edit"
    end

    fill_in :meal_name, with: "New meal"
    fill_in :meal_calories, with: "1000"
    fill_in :meal_eaten_at, with: "2015-06-12T12:00:00"
    click_button "Save"

    page.must_have_content "All meals"

    Meal.count.must_equal 1

    meal = Meal.last
    meal.name.must_equal "New meal"
    meal.calories.must_equal 1000
    meal.eaten_at.must_equal Time.parse("Fri, 12 Jun 2015 12:00:00 UTC +00:00")
  end

  scenario "are removed", js: true do
    other_user = create_user(name: "User 1", email: "user1@example.com")
    other_user.meals.create!(name: "Meal 1", calories: 100, eaten_at: Time.now)

    create_user_and_sign_in

    visit meals_path

    within "#meals" do
      click_link "Remove"
    end

    page.must_have_content "All meals"

    Meal.count.must_equal 0
  end
end
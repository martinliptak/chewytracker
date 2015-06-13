require "test_helper"

feature "Dashboard" do
  let(:user) { FactoryGirl.create(:user, expected_calories: 1000) }

  scenario "Listing meals", js: true do
    sign_in(user)

    page.must_have_content "There aren't any meals yet."

    FactoryGirl.create(:meal, user: current_user, name: "Meal 1", calories: 100)
    FactoryGirl.create(:meal, user: current_user, name: "Meal 2", calories: 200, eaten_at: Time.now - 2.days)
    visit dashboard_path

    page.must_have_content "Meal 1"
    page.must_have_content "Meal 2"
    page.must_have_content "100"
    page.must_have_content "200"
  end

  scenario "Filtering meals", js: true do
    sign_in(user)

    FactoryGirl.create(:meal, user: current_user, name: "Meal 1", calories: 100)
    FactoryGirl.create(:meal, user: current_user, name: "Meal 2", calories: 200, eaten_at: Time.now - 2.days)
    visit dashboard_path

    fill_in :filter_date_from, with: Date.today.to_formatted_s(:iso8601) # just the latest meal
    click_button "Apply"

    page.must_have_content "Meal 1"
    page.wont_have_content "Meal 2"

    click_link "clear filters"

    page.must_have_content "Meal 1"
    page.must_have_content "Meal 2"
  end

  scenario "Counting calories", js: true do
    sign_in(user)

    FactoryGirl.create(:meal, user: current_user, name: "Meal 1", calories: 100)
    FactoryGirl.create(:meal, user: current_user, name: "Meal 2", calories: 200)
    FactoryGirl.create(:meal, user: current_user, name: "Meal 3", calories: 300, eaten_at: Time.now - 2.days)
    visit dashboard_path

    page.wont_have_content "That's enough for today!"

    current_user.meals.create!(name: "Meal 4", calories: 900, eaten_at: Time.now)
    visit dashboard_path

    page.must_have_content "That's enough for today!"    
  end

  scenario "Adding meals", js: true do
    sign_in(user)

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

  scenario "Editing own meals", js: true do
    sign_in(user)

    FactoryGirl.create(:meal, user: current_user, name: "Meal 1", calories: 100)
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

  scenario "Removing own meals", js: true do
    sign_in(user)

    FactoryGirl.create(:meal, user: current_user, name: "Meal 1", calories: 100)
    visit dashboard_path

    within "#meals" do
      click_link "Remove"
    end

    page.must_have_content "My meals"

    Meal.count.must_equal 0
  end
end
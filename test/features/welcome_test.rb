require "test_helper"

feature "Landing page" do
  scenario "shows application title" do
    visit root_path
    page.must_have_content "MealTracker"
  end
end
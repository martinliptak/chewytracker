require "test_helper"

feature "Landing page" do
  scenario "shows application title", js: true do
    visit welcome_path
    page.must_have_content "Track your daily calories."
  end
end
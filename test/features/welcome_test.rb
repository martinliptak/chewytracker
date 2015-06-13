require "test_helper"

feature "Landing page" do
  scenario "Showing landing page", js: true do
    visit welcome_path
    page.must_have_content "Track your daily calories."
  end
end
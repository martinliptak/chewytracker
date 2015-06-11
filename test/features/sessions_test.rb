require "test_helper"

feature "Session" do
  scenario "is created", js: true do
    User.create!(name: "I Am Grook", email: "iamgrook@example.com", password: "password", password_confirmation: "password")

    visit welcome_path

    click_link "Sign in"

    within "#session_form" do
        fill_in :session_form_email, with: "iamgrook@example.com"
        fill_in :session_form_password, with: "password"
        click_button "Sign in"
    end

    page.must_have_content "I Am Grook"
  end

  scenario "is destroyed", js: true do
    User.create!(name: "I Am Grook", email: "iamgrook@example.com", password: "password", password_confirmation: "password")

    visit welcome_path

    click_link "Sign in"

    within "#session_form" do
        fill_in :session_form_email, with: "iamgrook@example.com"
        fill_in :session_form_password, with: "password"
        click_button "Sign in"
    end

    click_link "I Am Grook"
    click_link "Sign out"
    page.must_have_content "MealTracker"
  end
end
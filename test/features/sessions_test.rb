require "test_helper"

feature "Sessions" do
  scenario "are created", js: true do
    create_user

    visit welcome_path

    click_link "Sign in"

    within "#session_form" do
        fill_in :session_form_email, with: "iamgrook@example.com"
        fill_in :session_form_password, with: "password"
        click_button "Sign in"
    end

    page.must_have_content "I Am Grook"
  end

  scenario "are destroyed", js: true do
    create_user_and_sign_in

    click_link "I Am Grook"
    click_link "Sign out"
    page.must_have_content "Track your daily calories."
  end
end
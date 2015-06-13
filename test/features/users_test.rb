require "test_helper"

feature "Users" do
  scenario "Signing up with valid inputs", js: true do
    visit welcome_path

    click_link "Sign up"
    current_path.must_equal new_user_path

    within "#user_form" do
      fill_in :user_name, with: "I Am Grook"
      fill_in :user_email, with: "iamgrook@example.com"
      fill_in :user_password, with: "password"
      fill_in :user_password_confirmation, with: "password"
      fill_in :user_expected_calories, with: "1000"
      click_button "Sign up"
    end

    page.must_have_content "I Am Grook"

    User.count.must_equal 1

    user = User.last
    user.role.must_equal "regular"
    user.name.must_equal "I Am Grook"
    user.email.must_equal "iamgrook@example.com"
    user.expected_calories.must_equal 1000
  end

  scenario "Signing up without filling in required inputs", js: true do
    visit new_user_path

    click_button "Sign up"

    page.must_have_content "can't be blank"

    User.count.must_equal 0
  end

  scenario "Changing settings", js: true do
    create_user_and_sign_in

    click_link "I Am Grook"
    click_link "Settings"
    current_path.must_equal settings_path

    within "#user_form" do
      fill_in :user_name, with: "I Am Grook 2"
      fill_in :user_email, with: "iamgrook2@example.com"
      fill_in :user_password, with: "password"
      fill_in :user_password_confirmation, with: "password"
      fill_in :user_expected_calories, with: "5000"
      click_button "Save"
    end

    page.must_have_content "I Am Grook 2"
    current_path.must_equal dashboard_path

    User.count.must_equal 1

    user = User.last
    user.role.must_equal "regular"
    user.name.must_equal "I Am Grook 2"
    user.email.must_equal "iamgrook2@example.com"
    user.expected_calories.must_equal 5000
  end
end
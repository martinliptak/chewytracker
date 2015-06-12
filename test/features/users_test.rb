require "test_helper"

feature "Users" do
  scenario "sign up", js: true do
    visit welcome_path

    click_link "Sign up"
    current_path.must_equal new_user_path

    within "#user_form" do
      fill_in :user_name, with: "I Am Grook"
      fill_in :user_email, with: "iamgrook@example.com"
      fill_in :user_password, with: "password"
      fill_in :user_password_confirmation, with: "password"
      fill_in :user_expected_calories, with: "2000"
      click_button "Sign up"
    end

    page.must_have_content "I Am Grook"

    User.count.must_equal 1

    user = User.last
    user.role.must_equal "regular"
    user.name.must_equal "I Am Grook"
    user.email.must_equal "iamgrook@example.com"
    user.expected_calories.must_equal 2000
  end

  scenario "don't fill in required inputs", js: true do
    visit new_user_path

    click_button "Sign up"

    page.must_have_content "can't be blank"

    User.count.must_equal 0
  end
end
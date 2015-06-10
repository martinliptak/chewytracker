require "test_helper"

feature "Users" do
  scenario "sign up" do
    visit root_path

    click_link "Sign up"
    current_path.must_equal new_users_path

    fill_in :user_name, with: "I Am Grook"
    fill_in :user_email, with: "iamgrook@example.com"
    fill_in :user_password, with: "password"
    fill_in :user_password_confirmation, with: "password"
    click_button "Sign up"

    User.count.must_equal 1

    user = User.last
    user.role.must_equal "regular"
    user.name.must_equal "I Am Grook"
    user.email.must_equal "iamgrook@example.com"
  end
end
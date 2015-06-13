require "test_helper"

feature "Managing users" do
  scenario "Listing users", js: true do
    create_user(name: "User 1", email: "user1@example.com")
    create_user(name: "User 2", email: "user2@example.com")

    create_user_and_sign_in

    click_link "Manage"
    click_link "Users"
    current_path.must_equal users_path

    page.must_have_content "User 1"
    page.must_have_content "User 2"
  end

  scenario "Editing other users", js: true do
    user = create_user(name: "User 1", email: "user2@example.com")

    create_user_and_sign_in

    visit users_path

    within "tr[data-id=\"#{user.id}\"]" do
      click_link "Edit"
    end
    current_path.must_equal edit_user_path(user)

    within "#user_form" do
      fill_in :user_name, with: "I Am Grook 2"
      fill_in :user_email, with: "iamgrook2@example.com"
      fill_in :user_password, with: "password"
      fill_in :user_password_confirmation, with: "password"
      fill_in :user_expected_calories, with: "5000"
      click_button "Save"
    end

    page.must_have_content "I Am Grook 2"
    current_path.must_equal users_path

    User.count.must_equal 2

    user.reload
    user.role.must_equal "regular"
    user.name.must_equal "I Am Grook 2"
    user.email.must_equal "iamgrook2@example.com"
    user.expected_calories.must_equal 5000
  end

  scenario "Removing other users", js: true do
    user = create_user(name: "User 1", email: "user2@example.com")

    create_user_and_sign_in

    visit users_path

    within "tr[data-id=\"#{user.id}\"]" do
      click_link "Remove"
    end
    page.wont_have_content "User 1"
    current_path.must_equal users_path

    User.count.must_equal 1
  end
end
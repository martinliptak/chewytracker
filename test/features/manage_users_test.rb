require "test_helper"

feature "Managing users" do
  let(:user) { FactoryGirl.create(:user) }
  let(:user_manager) { FactoryGirl.create(:user, role: "user_manager") }
  let(:admin) { FactoryGirl.create(:user, role: "admin") }

  scenario "Regular users trying to manage users", js: true do
    sign_in(user)

    page.wont_have_link "Manage"    
  end

  scenario "Regular users trying to change role", js: true do
    sign_in(user)

    visit settings_path

    page.wont_have_select "Role"
  end

  scenario "Listing users", js: true do
    FactoryGirl.create(:user, name: "User 1", email: "user1@example.com")
    FactoryGirl.create(:user, name: "User 2", email: "user2@example.com")

    sign_in(user_manager)

    click_link "Manage"
    click_link "Users"
    current_path.must_equal users_path

    page.must_have_content "User 1"
    page.must_have_content "User 2"
  end

  scenario "Editing other users", js: true do
    user = FactoryGirl.create(:user, name: "User 1", email: "user1@example.com")

    sign_in(user_manager)

    visit users_path

    within "tr[data-id=\"#{user.id}\"]" do
      click_link "Edit"
    end
    current_path.must_equal edit_user_path(user)

    page.wont_have_select "Role"

    within "#user_form" do
      fill_in :user_name, with: "I Am Groot 2"
      fill_in :user_email, with: "iamgrook2@example.com"
      fill_in :user_password, with: "password"
      fill_in :user_password_confirmation, with: "password"
      fill_in :user_expected_calories, with: "5000"

      click_button "Save"
    end

    page.must_have_content "User I Am Groot 2 saved"
    page.must_have_content "I Am Groot 2"
    current_path.must_equal users_path

    User.count.must_equal 2

    user.reload
    user.role.must_equal "regular"
    user.name.must_equal "I Am Groot 2"
    user.email.must_equal "iamgrook2@example.com"
    user.expected_calories.must_equal 5000
  end

  scenario "Changing roles", js: true do
    user = FactoryGirl.create(:user, name: "User 1", email: "user1@example.com")

    sign_in(admin)

    visit edit_user_path(user)

    within "#user_form" do
      fill_in :user_name, with: "I Am Groot 2"
      select "User manager", from: "Role"

      click_button "Save"
    end

    page.must_have_content "User I Am Groot 2 saved"
    page.must_have_content "I Am Groot 2"

    User.count.must_equal 2

    user.reload
    user.role.must_equal "user_manager"
    user.name.must_equal "I Am Groot 2"
  end

  scenario "Removing other users", js: true do
    user = FactoryGirl.create(:user, name: "User 1", email: "user1@example.com")

    sign_in(user_manager)

    visit users_path

    within "tr[data-id=\"#{user.id}\"]" do
      click_link "Remove"
    end
    
    page.must_have_content "User User 1 removed"
    within "table" do
      page.wont_have_content "User 1"
    end

    current_path.must_equal users_path

    User.count.must_equal 1
  end

  scenario "Removing herself", js: true do
    sign_in(user_manager)

    visit users_path

    page.wont_have_link "Remove"
  end
end
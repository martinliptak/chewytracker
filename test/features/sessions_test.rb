require "test_helper"

feature "Sessions" do
  let(:user) { FactoryGirl.create(:user) }

  scenario "Signing in", js: true do
    visit welcome_path

    click_link "Sign in"

    within "#session_form" do
        fill_in :session_form_email, with: user.email
        fill_in :session_form_password, with: user.password
        click_button "Sign in"
    end

    page.must_have_content "I Am Grook"
  end

  scenario "Signing out", js: true do
    sign_in(user)

    click_link "I Am Grook"
    click_link "Sign out"
    page.must_have_content "Track your daily calories."
  end
end
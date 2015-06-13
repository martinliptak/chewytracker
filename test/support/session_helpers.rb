module SessionHelpers
  def sign_in(user)
    visit sign_in_path
    within "#session_form" do
      fill_in :session_form_email, with: user.email
      fill_in :session_form_password, with: user.password
      click_button "Sign in"
    end
    page.must_have_content user.name # wait

    @@user = user
  end

  def current_user
    @@user
  end
end
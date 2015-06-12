module SessionHelpers
  def create_user(params = {})
    defaults = { 
      name: "I Am Grook", 
      email: "iamgrook@example.com", 
      password: "password", 
      password_confirmation: "password"
    }
    User.create! defaults.merge(params)
  end

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

  def create_user_and_sign_in(params = {})
    user = create_user(params)
    sign_in(user)
  end

  def current_user
    @@user
  end
end
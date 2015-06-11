class SessionForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  def persisted?
    false
  end

  attr_accessor :email, :password
  attr_reader :user

  def submit(params)
    @user = User.find_by_email(params[:session_form][:email])
    if @user && @user.authenticate(params[:session_form][:password])
      true
    else
      errors[:password] << "Email or password is invalid"
      self.email = params[:session_form][:email]
      false
    end
  end
end
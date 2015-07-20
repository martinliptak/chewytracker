class SessionForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  def persisted?
    false
  end

  attr_accessor :email, :password
  attr_reader :user, :session

  def initialize(session)
    @session = session
  end

  def submit(params)
    self.email = params[:email]
    user = User.authenticate_with_email_and_password(email, params[:password])
    if user
      session[:user_id] = user.id
      true
    else
      errors[:password] << "Email or password is invalid"
      false
    end
  end
end
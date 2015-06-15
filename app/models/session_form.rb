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
    @user = User.find_by_email(params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = user.id
      true
    else
      errors[:password] << "Email or password is invalid"
      self.email = params[:email]
      false
    end
  end
end
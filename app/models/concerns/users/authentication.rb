module Users
  module Authentication
    extend ActiveSupport::Concern
  
    included do
      has_secure_password
    end

    class_methods do
      def authenticate_with_email_and_password(email, password)
        user = where(email: email).first
        user && user.authenticate(password)
      end
    end
  end
end

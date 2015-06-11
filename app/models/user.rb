class User < ActiveRecord::Base
  before_save :default_values

  has_secure_password
  
  serialize :settings

  validates_presence_of :name, :email, :password, :password_confirmation
  validates_uniqueness_of :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_confirmation_of :password

  private

    def default_values
      self.settings ||= {}
    end
end

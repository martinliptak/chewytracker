class User < ActiveRecord::Base
  include Users::Authentication
  include Users::Settings

  ROLES = %w{regular user_manager admin}
  DEFAULT_ROLE = "regular"

  after_initialize :default_values
  
  validates_presence_of :name, :email
  validates_uniqueness_of :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  validates_presence_of :password, on: :create
  validates_confirmation_of :password, on: :create
  validates_length_of :password, within: 5..40, allow_blank: true

  has_many :meals, dependent: :destroy
  has_many :access_tokens, dependent: :destroy

  default_scope ->{ order("id DESC") }

  private

    def default_values
      self.role ||= DEFAULT_ROLE
    end
end

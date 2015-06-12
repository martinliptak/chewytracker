class User < ActiveRecord::Base
  after_initialize :default_values

  has_secure_password
  
  serialize :settings, Hash

  validates_presence_of :name, :email, :password, :password_confirmation
  validates_uniqueness_of :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_confirmation_of :password

  has_many :meals

  def expected_calories
    settings[:expected_calories] || 2000
  end

  def expected_calories=(v)
    settings[:expected_calories] = v
  end

  def total_calories
    meals.where("eaten_at::date = current_date").sum(:calories)
  end

  private

    def default_values
      self.role ||= "regular"
    end
end

class User < ActiveRecord::Base
  after_initialize :default_values

  has_secure_password
  
  serialize :settings, Hash

  validates_presence_of :name, :email
  validates_uniqueness_of :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  validates_presence_of :password, on: :create
  validates_confirmation_of :password, on: :create

  has_many :meals

  def expected_calories
    settings[:expected_calories] || 2000
  end

  def expected_calories=(v)
    settings[:expected_calories] = v.to_i
  end

  def total_calories
    meals.where("eaten_at::date = current_date").sum(:calories)
  end

  private

    def default_values
      self.role ||= "regular"
    end
end

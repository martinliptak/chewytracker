class User < ActiveRecord::Base
  before_save :default_values

  has_secure_password
  
  serialize :settings

  validates_uniqueness_of :email

  private

    def default_values
      self.settings ||= {}
    end
end

class AccessToken < ActiveRecord::Base
  belongs_to :user

  before_create :generate_name
  before_create :set_expires_at

  def expired?
    expires_at < Time.now
  end

  private

  def generate_name
    begin
      self.name = SecureRandom.hex
    end while self.class.exists?(name: name)
  end 

  def set_expires_at
    self.expires_at = created_at + 2.weeks
  end
end

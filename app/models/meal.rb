class Meal < ActiveRecord::Base
  include Filterable
  
  belongs_to :user

  validates_presence_of :name, :calories, :eaten_at

  default_scope ->{ order("eaten_at DESC") }

  scope :date_from, -> (date_from) { where("eaten_at::date >= ?", date_from) }
  scope :date_to, -> (date_to) { where("eaten_at::date <= ?", date_to) }
  scope :time_from, -> (time_from) { where("eaten_at::time >= ?", time_from) }
  scope :time_to, -> (time_to) { where("eaten_at::time <= ?", time_to) }

  scope :user_id, -> (user_id) { where(user_id: user_id) }
end

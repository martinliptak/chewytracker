class Meal < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :name, :calories, :eaten_at
end

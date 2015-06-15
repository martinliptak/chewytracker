class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :users, :email

    execute "CREATE INDEX eaten_at_date_on_meals ON meals ((eaten_at::date))"
    execute "CREATE INDEX eaten_at_time_on_meals ON meals ((eaten_at::time))"
  end
end

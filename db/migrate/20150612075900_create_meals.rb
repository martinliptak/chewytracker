class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.references :user, index: true
      t.string :name, null: false
      t.integer :calories, null: false
      t.datetime :eaten_at, null: false, index: true

      t.timestamps null: false
    end
  end
end

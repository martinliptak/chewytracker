class CreateAccessTokens < ActiveRecord::Migration
  def change
    create_table :access_tokens do |t|
      t.string :name, index: true, null: false
      t.references :user, index: true, foreign_key: true, null: false
      t.datetime :expires_at, index: true, null: false

      t.timestamps null: false
    end
  end
end

class CreateReactions < ActiveRecord::Migration
  def change
    create_table :reactions do |t|
      t.integer :emotion, null: false, default: 0, limit: 1
      t.integer :user_id, null: false
      t.integer :tweet_id, null: false

      t.timestamps null: false
    end
  end
end

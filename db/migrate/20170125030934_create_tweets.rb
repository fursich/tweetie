class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.integer :user_id, null: false
      t.integer :retweet_id
      t.string :content, null: false

      t.timestamps null: false
    end
  end
end

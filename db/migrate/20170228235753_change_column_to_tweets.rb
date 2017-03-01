class ChangeColumnToTweets < ActiveRecord::Migration
  def change
    add_index :tweets, :user_id
    add_index :tweets, :retweet_id
  end
end

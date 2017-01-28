class AddRetweetIdColumnToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :retweet_id, :integer
  end
  add_index :tweets, :retweet_id, unique: true
end

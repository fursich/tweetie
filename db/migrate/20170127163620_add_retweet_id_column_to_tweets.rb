class AddRetweetIdColumnToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :retweet_id, :integer
  end
end

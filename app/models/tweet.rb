class Tweet < ActiveRecord::Base
    belongs_to :user
    has_many :retweets, class_name: :Tweet, foreign_key: :retweet_id, dependent: :destroy

    validates :user_id, presence: true
    validates :content, presence: true, length: {maximum: 140}

    scope :first_tweets, -> do
        where(retweet_id: nil)
    end
end

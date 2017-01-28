class Tweet < ActiveRecord::Base
    belongs_to :user
    has_many :retweets, class_name: :Tweet, foreign_key: :retweet_id, dependent: :destroy #返信をretweetsで参照

    validates :user_id, presence: true
    validates :content, presence: true, length: {maximum: 140} #tweet内容は140文字制限

    scope :first_tweets, -> do    # オリジナルのTweet(返信ではないもの)だけを返すTweetモデルのscope
        where(retweet_id: nil)
    end
end

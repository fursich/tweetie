class Tweet < ActiveRecord::Base
    belongs_to :user
    has_many :retweets, class_name: :Tweet, foreign_key: :retweet_id, dependent: :destroy #返信をretweetsで参照
    belongs_to :parent_tweet, class_name: Tweet, foreign_key: :retweet_id #返信元をparent_tweetで参照

    validates :user_id, presence: true
    validates :content, presence: true, length: {maximum: 140} #tweet内容は140文字制限

    scope :first_tweets, -> do    # オリジナルのTweet(返信ではないもの)だけを返すTweetモデルのscope
        where(retweet_id: nil)
    end
    def has_parent?  #見通しを良くするためメソッド化(リツイートかどうかを返す)
        !self.retweet_id.nil?
    end
    def first_parent    #返信元をたどっていき､最初のツイートを返す(今回未使用)
        ch = self
        while ch.retweet_id.present?
            ch=Tweet.find(ch.retweet_id)
        end
        return ch
    end
end

class Tweet < ActiveRecord::Base
    belongs_to :user
    has_many :reactions
    
    has_many :retweets, class_name: :Tweet, foreign_key: :retweet_id, dependent: :destroy #返信をretweetsで参照
    belongs_to :parent_tweet, class_name: Tweet, foreign_key: :retweet_id #返信元をparent_tweetで参照

    validates :user_id, presence: true
    validates :content, presence: true, length: {maximum: 140} #tweet内容は140文字制限

    scope :first_tweets, -> do    # オリジナルのTweet(返信ではないもの)だけを返すTweetモデルのscope
        where(retweet_id: nil)
    end
    scope :sort_by_created_date_with, -> (page_num) do
        page(page_num).per(10).order('created_at DESC')
    end

    def has_parent?  #リツイートかどうかを返す
        !self.retweet_id.nil?
    end

    def first_parent    #返信元をたどっていき､最初のツイートを返す(今回未使用)
        ch = self
        while ch.retweet_id.present?
            ch=Tweet.find(ch.retweet_id)
        end
        return ch
    end

    def has_emotion_by_user? (emotion, user_id)   #ツイートに対するUserのemotionがあればtrue / なければfalse
        return false unless r = Reaction.find_by(tweet_id: self.id, user_id: user_id)
        r.has_emotion?(emotion)
    end

    def has_any_reactions?   #ツイートに対するリアクションがあればtrue / なければfalse
        self.reactions.present?
    end

    def count_reactions   #あるツイートに対するリアクション数をハッシュで返す
        counter={}
        Reaction.emotions.each do |emotion, emotion_id|
            counter.store(emotion, self.reactions.where(:emotion, emotion).size)
        end
        return counter
    end

    def count_reactions_by_emotion_id (emotion_id)
        self.reactions.where('emotion=?', emotion_id).size
    end
    
end

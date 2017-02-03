class Reaction < ActiveRecord::Base
    belongs_to :tweet
    belongs_to :user

    enum emotion: {na: 0, like: 1, love: 2, laugh: 3, wonder: 4, weep: 5, anger: 6}
    validates :emotion, presence: true
    validates :user_id, presence: true
    validates :tweet_id, presence: true
    
    def has_emotion?(emotion)
        !! (self.emotion == emotion)
    end
    def reset_emotion!
        self.emotion.na!
    end
end

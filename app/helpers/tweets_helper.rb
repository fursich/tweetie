module TweetsHelper
    def my_tweet? (tweet)
        tweet.user_id==current_user.id
    end
end

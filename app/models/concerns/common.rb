module Common
  extend ActiveSupport::Concern

  def create_emotion_array

    tmp_hash = Reaction.group(:emotion).group(:tweet_id).count()
    emotions_hash = Reaction.emotions
    result=Array.new(emotions_hash.size){[]}

    emotions_hash.each do |emo, emo_id|
      Tweet.ids.each do |tweet_id|
        result[emo_id][tweet_id] = tmp_hash.has_key?([emo_id, tweet_id]) ? tmp_hash[[emo_id, tweet_id]] : 0
      end
    end
    result
  end
  
end

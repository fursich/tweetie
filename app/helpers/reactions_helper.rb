module ReactionsHelper

    def class_by_emotion(emotion)
        case emotion
        when 'like'
            return "em em-thumbsup like-icon"
        when 'love'
            return "em em-heart love-icon"
        when 'laugh'
            return "em em-laughing laugh-icon"
        when 'wonder'
            return "em em-open_mouth wonder-icon"
        when 'weep'
            return "em em-cry weep-icon"
        when 'anger'
            return "em em-angry anger-icon"
        else
            return "na"
        end
    end

end

class Relationship < ActiveRecord::Base

    belongs_to :following, class_name: :User, foreign_key: :follower_id
    belongs_to :followed, class_name: :User, foreign_key: :followed_id

end

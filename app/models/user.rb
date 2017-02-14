class User < ActiveRecord::Base
  has_many :tweets, dependent: :destroy
  has_many :reactions, dependent: :destroy
  has_one :user_config, dependent: :destroy
  has_many :outgoing_relationships, class_name: :Relationship, foreign_key: :follower_id, dependent: :destroy
  has_many :incoming_relationships, class_name: :Relationship, foreign_key: :followed_id, dependent: :destroy

  has_many :following, through: :outgoing_relationships, source: :followed
  has_many :followers, through: :incoming_relationships, source: :following

  VALID_NAME =  /\A[a-zA-Z0-9_]+\z/  #アカウント名はアルファベット/数字/アンダースコアのみとする｡冒頭がアンダースコア､アンダースコア複数連結などは許可
  validates :name, presence: true, uniqueness: true, length: {minimum: 4, maximum: 20}, format: { with: VALID_NAME }

  # Include default devise modules. Others available are:
  # :confirmable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable, :omniauthable

  validates :image, file_size: { maximum: 500.kilobytes.to_i }  #画像に500kb制限をかける(ただしアップロード後にはじく仕様) 
  validates :profile, presence: true, length: {maximum: 200}    #プロフィールは200文字まで

  mount_uploader :image, UserImageUploader
  
  def image_url  #イメージファイルが無い場合は､デフォルト画像のパスを渡す
    self.image? ? self.image.url : 'noimage.png'
  end
  def admin?
    !!self.admin
  end
  def via_sns?
    self.provider && self.provider_token && self.provider_uid
  end
  
  def follow!(another_user)
    outgoing_relationships.create(followed_id: another_user.id)
  end
  def unfollow!(another_user)
    outgoing_relationships.find_by(followed_id: another_user.id).destroy
  end
  def following?(another_user)
    following.include?(another_user)
  end
  def followed_by?(another_user)
    followers.include?(another_user)
  end
  
end

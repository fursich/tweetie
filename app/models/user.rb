class User < ActiveRecord::Base
  has_many :tweets, dependent: :destroy

  VALID_NAME =  /\A[a-zA-Z0-9_]+\z/  #アカウント名はアルファベット/数字/アンダースコアのみとする｡冒頭がアンダースコア､アンダースコア複数連結などは許可
  validates :name, presence: true, uniqueness: true, length: {minimum: 8, maximum: 20}, format: { with: VALID_NAME }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :image, file_size: { maximum: 500.kilobytes.to_i }  #画像に500kb制限をかける(ただしアップロード後にはじく仕様) https://gist.github.com/chrisbloom7/1009861
  validates :profile, presence: true, length: {maximum: 200}    #プロフィールは200文字まで
         
  mount_uploader :image, UserImageUploader
  
  def image_url  #イメージファイルが無い場合は､デフォルト画像のパスを渡す
    self.image? ? self.image.url : 'noimage.png'
  end
end

class User < ActiveRecord::Base
  has_many :tweets, dependent: :destroy

  VALID_NAME =  /\A[a-zA-Z0-9_]+\z/
  validates :name, presence: true, uniqueness: true, length: {minimum: 8, maximum: 20}, format: { with: VALID_NAME }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :image, file_size: { maximum: 500.kilobytes.to_i }
  validates :profile, presence: true, length: {maximum: 200}
         
  mount_uploader :image, UserImageUploader
  
  def image_url
    self.image? ? self.image.url : 'noimage.png'
  end
end

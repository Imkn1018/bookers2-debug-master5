class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :followers, through: :active_relationships, source: :follower
  has_many :passive_relationships, class_name: "Relationship", foreign_key: :followed_id
  has_many :followeds, through: :passive_relationships, source: :following

   # フォロー取得 # フォロワー取得 # 自分がフォローしている人 # 自分をフォローしている人
  validates :name, uniqueness: true, length: {minimum: 2, maximum: 20}
  validates :introduction, length:{maximum: 50}
  attachment :profile_image
  # ユーザーをフォローする
  def followed_by?(user)
    passive_relationships.where(follower_id: user.id).exists?
  end

  def self.looks(search, word)
      if search == "perfect_match"
        @user = User.where("name LIKE?", "#{word}")
      elsif search == "forward_match"
        @user = User.where("name LIKE?","#{word}%")
      elsif search == "backward_match"
        @user = User.where("name LIKE?","%#{word}")
      elsif search == "partial_match"
        @user = User.where("name LIKE?","%#{word}%")
      else
        @user = User.all
      end
  end
end

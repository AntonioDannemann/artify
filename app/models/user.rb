class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :histories, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_monuments, through: :favorites, source: :monument
  has_one_attached :photo

  validates :first_name, :last_name, presence: true

  def self.destroy_guests
    User.destroy_by(first_name: "guest", last_name: nil)
  end

  def full_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end
end

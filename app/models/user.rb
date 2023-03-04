class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :photo

  validates :first_name, :last_name, :lat, :lng, presence: true
  validates :lat, :lng, numericality: { only_float: true }

  def full_name
    "#{first_name} #{last_name}"
  end
end

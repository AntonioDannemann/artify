class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :photo

  validates :first_name, :last_name, :latitude, :longitude, presence: true
  validate :full_name

  def full_name
    return "#{first_name} #{last_name}" if first_name.present? && last_name.present?
  end
end

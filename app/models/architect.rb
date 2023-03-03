class Architect < ApplicationRecord
  validates :name, :birth_date, :death_date, :nationality, :description, presence: true
  validate :death_date_later_than_birth_date?

  private

  def death_date_later_than_birth_date?
    return if death_date > birth_date
    errors.add(:birth_date, "can't be later than date of death")
  end
end

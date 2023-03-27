class FavouritePolicy < ApplicationPolicy
  def create?
    true
  end

  def destroy?
    @record.user == user
  end

  class Scope < Scope
    def resolve
      scope.where(user: user.current)
    end
  end
end

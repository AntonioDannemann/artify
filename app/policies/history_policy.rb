class HistoryPolicy < ApplicationPolicy
  def show?
    record.user == (user.current || user.guest)
  end

  def create?
    true
  end

  class Scope < Scope
    def resolve
      scope.where(user:)
    end
  end
end

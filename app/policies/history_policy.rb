class HistoryPolicy < ApplicationPolicy
  def show?
    true
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

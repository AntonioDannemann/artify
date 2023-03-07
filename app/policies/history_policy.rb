class HistoryPolicy < ApplicationPolicy
  def show?
    true
  end

  def create?
    true
  end

  class Scope < Scope
  end
end

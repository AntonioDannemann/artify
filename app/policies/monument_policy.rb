class MonumentPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.Monument.near([user.lat, user.lng], 5)
    end
  end

  def show?
    true
  end
end

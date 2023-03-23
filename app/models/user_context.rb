class UserContext
  attr_reader :current, :guest

  def initialize(current_user, guest)
    @current = current_user
    @guest = guest
  end
end

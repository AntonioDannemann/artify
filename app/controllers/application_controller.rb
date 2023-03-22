class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  include Pundit::Authorization

  # Pundit: allow-list approach
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name photo])

    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name photo])
  end

  # Uncomment when you *really understand* Pundit!
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # def user_not_authorized
  #   flash[:alert] = "You are not authorized to perform this action."
  #   redirect_to(root_path)
  # end

  def guest_user
    id = session[:guest_user_id] || session[:guest_user_id] = create_guest_user.id
    user = User.find_by(id:)
    return user if user

    session.delete(:guest_user_id)
    guest_user
  end

  def pundit_user
    UserContext.new(current_user, guest_user)
  end

  private

  def create_guest_user
    user = User.new(first_name: "guest", email: "#{Time.current.to_i}#{rand(999)}@guest.artify")
    user.save(validate: false)

    user
  end

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end
end

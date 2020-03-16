class ApplicationController < ActionController::Base
  include Pundit
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, unless: [:devise_controller?, :drivers_controller?]
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  def standard_nav
    @nav_bar_partial = "path/to/standard/nav/partial"
  end
  
  def after_sign_up_path_for(resource)
    raise
    edit_user_registration_path
  end

  def after_sign_in_path_for(resource)
    if current_driver
      '/driver/dashboard'
    else
      if resource.user_rewards.empty?
        '/onboarding'
      else
        '/dashboard'
      end
    end
  end

  private

  def drivers_controller?
    params[:controller].match?(/drivers/)
  end

  def skip_pundit? #
    params[:controller] !~ /pickups/
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:address, :user_name])
  end
end

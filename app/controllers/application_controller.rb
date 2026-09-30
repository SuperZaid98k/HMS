class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
  protected
  def configure_permitted_parameters
    # Permit :name on sign up
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  
    # Permit :name when updating profile/account settings
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end
end

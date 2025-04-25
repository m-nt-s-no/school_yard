class ApplicationController < ActionController::Base
  include Pundit
  skip_forgery_protection
  before_action :authenticate_user!
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :display_navbar?

  def display_navbar?
    #Doesn't display navbar on the landing page to keep it internal
    !(controller_name == 'page' && action_name == 'landing')
  end

  private

  def after_sign_out_path_for(resource_or_scope)
    unauthenticated_root_path
  end

  def after_sign_in_path_for(resource_or_scope)
    authenticated_root_path
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back fallback_location: authenticated_root_url
  end

  protected

  def configure_permitted_parameters
    #name, role, avatar permitted on user signup
    devise_parameter_sanitizer.permit(
      :sign_up,
      { :keys => [:name, :role, :avatar] }
    )

    #only avatar permitted on user update
    #since we don't have way to change name or role for now
    devise_parameter_sanitizer.permit(
      :account_update,
      { :keys => [:avatar] }
    )
  end
end

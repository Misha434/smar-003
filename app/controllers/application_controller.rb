class ApplicationController < ActionController::Base
  prepend_view_path Rails.root.join("frontend")
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  private

  def admin_user
    @user = authenticate_user!
    unless @user.admin?
      flash[:danger] = "Access denied"
      redirect_to @user || request.referrer
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: %i[avatar])
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[avatar])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end

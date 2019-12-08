class ApplicationController < ActionController::Base
  layout :layout_by_resource

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    attrs = [:first_name, :last_name, :role, :organization_id]
    devise_parameter_sanitizer.permit :accept_invitation, keys: attrs
  end

  private

  def layout_by_resource
    if devise_controller?
      'devise'
    else
      'application'
    end
  end

  def require_super_admin_only!
    unless current_user.super_admin?
      flash[:warning] = "You are not allowed to do such things!"
      redirect_to controller: 'dashboard', action: 'index'
    end
  end

  def after_invite_path_for(resource)
    account_users_path
  end
end

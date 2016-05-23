class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_filter :configure_permitted_parameters, if: :devise_controller?

  # layout 'admin_lte_2'

  layout :layout

    protected

      def configure_permitted_parameters
          devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password) }
          devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:first_name, :last_name, :email, :password) }
      end

    private

    def layout
      # only turn it off for login pages:
      is_a?( Devise::RegistrationsController ) ? false : "admin_lte_2"
      # or turn layout off for every devise controller:
      # devise_controller? && "admin_lte_2"
    end


  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

#****User sign_in / sign_out page redirects****************#
  def after_sign_in_path_for(resource)
    if current_user.is_moderator? || current_user.is_admin?
      session["user_return_to"] || user_index_path
    else
      root_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    #byebug
        root_path 
  end
end

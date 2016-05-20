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
end

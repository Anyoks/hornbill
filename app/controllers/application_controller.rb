class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  # layout 'admin_lte_2'

  layout :layout

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

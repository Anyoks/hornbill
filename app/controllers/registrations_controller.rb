class RegistrationsController < Devise::RegistrationsController

  def create
    super
    if user_signed_in? and session[:sp_id].present?
      Authentication.find_by(id: session[:sp_id],user_id: nil).update(user_id: current_user.id)
    end
  end
end
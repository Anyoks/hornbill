class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # def twitter
  #   # You need to implement the method below in your model (e.g. app/models/user.rb)
  #   @user = User.from_omniauth(request.env["omniauth.auth"])

  #   if @user.persisted?
  #     sign_in_and_redirect user_index_path #, :event => :authentication #this will throw if @user is not activated
  #     set_flash_message(:notice, :success, :kind => "Twitter") if is_navigational_format?
  #   else
  #     session["devise.twitter_data"] = request.env["omniauth.auth"]
  #     # redirect_to new_user_registration_url
  #     redirect_to user_index_path
  #     set_flash_message(:notice, :success, :kind => "Twitter")
  #   end
  # end

  # def failure
  #   redirect_to root_path
  # end

  before_filter :prepare_auth

  def facebook
    connect(:facebook)
  end

  def twitter
    connect(:twitter)
  end

  def google_oauth2
    connect(:google)
  end

  private

    def prepare_auth
      @auth = request.env["omniauth.auth"]
    end

    def connect(provider_type)
        authentication = Authentication.find_for_oauth(@auth, provider_type)
        
        if user_signed_in?
          if authentication and authentication.user_id == current_user.id
            flash[:notice] = "Your #{provider_type} account is already attached"
            redirect_to current_user and return
          elsif authentication.user_id.nil?
            current_user.update_from_oauth(@auth, provider_type)
            current_user.authentications << authentication if current_user.save
            flash[:notice] = "Successfully attached #{provider_type} account"
            redirect_to current_user and return
          else
            flash[:notice] = "#{provider_type} is already connected to another account"
            redirect_to current_user and return
          end
        else
          byebug

          #If the user already exists or can be found by email provided in auth hash  if not create a new user.
          @user = authentication.user || User.find_by_email(@auth[:info][:email])|| User.new

          #If the auth doesn't have an email in the hash
          @authentication = Authentication.find_by_uid(@auth[:uid])
          @user.update_from_oauth(@auth, provider_type)
          authentication.save
          byebug
          if @user.persisted? # If user already has account and not logged in
            @user.authentications << authentication if @user.save
            flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => provider_type.capitalize
            sign_in_and_redirect @user, :event => :authentication
          elsif authentication.user.nil?
            @user = User.new
            @user.update_from_oauth(@auth, provider_type)
            @user.email = "#{@user.first_name}@gmail.com"
            @user.authentications << authentication if @user.save
            flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => provider_type.capitalize
            sign_in_and_redirect @user, :event => :authentication
            byebug
          else # If user has no account
            session[:sp_id] = authentication.id 
            redirect_to new_user_registration_url
          end
        end
      end




end
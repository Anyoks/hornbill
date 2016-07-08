class Authentication < ActiveRecord::Base
	belongs_to :user


	def self.find_for_oauth(auth, provider_type)
	    unless authentication = self.find_by(uid: auth[:uid].to_s, provider_type: provider_type)
	      user = User.find_by_email(auth[:info][:email])
	      authentication = user.authentications.where(provider_type: provider_type).first if user.present?
	      authentication ||= Authentication.new
	    end
	    authentication.update_from_oauth(auth, provider_type)
	    authentication
	  end

	def update_from_oauth(auth, provider_type)
		self.email= auth[:info][:email]
		self.uid= auth[:uid]
		self.provider_type= provider_type
		credentials = auth[:credentials]
		
		case provider_type
			when :twitter
			  self.token = credentials[:token]
			  self.token_secret = credentials[:secret]
			  self.url = auth[:info][:urls][:Twitter]
			# when :facebook
			#   ...
			# when :google
			#   ...
			end
	end

end

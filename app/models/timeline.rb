class Timeline < ActiveRecord::Base

	def initialize(token, secret)
	  @twitter_client = self.make_twitter_client(token, secret)
	  @tweets = []
	  @url_objs = []
	end


	def make_twitter_client(token, secret)
	  Twitter::REST::Client.new do |config|
	    config.consumer_key        = Rails.application.secrets.twitter_api_key
	    config.consumer_secret     = Rails.application.secrets.twitter_api_secret
	    config.access_token        = token
	    config.access_token_secret = secret
	  end
	end
end

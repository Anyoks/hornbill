json.array!(@authentications) do |authentication|
  json.extract! authentication, :id, :user_id, :povider, :uid
  json.url authentication_url(authentication, format: :json)
end

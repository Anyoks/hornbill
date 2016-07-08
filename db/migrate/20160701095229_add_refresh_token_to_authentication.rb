class AddRefreshTokenToAuthentication < ActiveRecord::Migration
  def change
    add_column :authentications, :refresh_token, :string
    add_column :authentications, :expires_at, :string
    add_column :authentications, :provider_type, :string
    add_column :authentications, :url, :string
    add_column :authentications, :email, :string
    rename_column :authentications, :povider, :provider
  end
end

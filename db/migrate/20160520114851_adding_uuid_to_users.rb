class AddingUuidToUsers < ActiveRecord::Migration
  def change
  	#Making uuid the primary key
  	add_column :users, :uuid, :uuid, :default => "uuid_generate_v4()"
  	remove_column :users, :id # remove existing primary key
  	rename_column :users, :uuid, :id # rename existing UDID column
  	execute "ALTER TABLE users ADD PRIMARY KEY (id);"
  end
end
